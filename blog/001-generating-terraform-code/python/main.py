#!python3

import json
import re
import subprocess
from typing import Any, List, Dict

import jinja2
import xxhash


def get_inventory() -> Dict[str, Any]:
    cmd = subprocess.run(["cue", "export", "inventory.cue"], capture_output=True, check=True)
    data = cmd.stdout.decode("utf-8")

    return json.loads(data)


def parse_nacl_rule(rule: str, number: int) -> Dict[str, str]:
    tokens = rule.split(" ")

    data = {tokens[idx]: tokens[idx + 1] for idx in range(0, len(tokens), 2)}

    if data["from"] == "any":
        data["from"] = "0.0.0.0/0"

    if data["to"] == "any":
        data["to"] = "0.0.0.0/0"

    if re.search(r":", data["port"]):
        (src_port, dest_port) = data["port"].split(":")

        data["src_port"] = src_port
        data["dest_port"] = dest_port

    else:
        data["src_port"] = data["port"]
        data["dest_port"] = data["port"]

    del data["port"]

    data["number"] = number
    data["id"] = xxhash.xxh32(rule).hexdigest()

    return data


def parse_nacl_rules(rules: List[str], start_number: int = 100) -> List[Dict[str, str]]:
    number = start_number
    data = []

    for rule in rules:
        rule = re.sub(r"\s+", " ", rule)

        if not rule == "deleted":
            data.append(parse_nacl_rule(rule, number))

        number += 1

    return data


def render_template(inventory: Dict[str, Any]) -> str:
    env = jinja2.Environment(
        loader=jinja2.FileSystemLoader("./")
    )

    template = env.get_template("template.jinja2")
    return template.render(inventory)


def main():
    inventory = get_inventory()

    for nacl in inventory["nacl"]:
        rules = inventory["nacl"][nacl]

        ingress = parse_nacl_rules(rules["ingress"])
        egress = parse_nacl_rules(rules["egress"])

        inventory["nacl"][nacl]["ingress"] = ingress
        inventory["nacl"][nacl]["egress"] = egress

    with open("generated.json", "w") as fh:
        print("writing generated.json")
        fh.write(json.dumps(inventory, indent=2, sort_keys=True))

    with open("generated.tf", "w") as fh:
        print("writing generated.tf")
        fh.write(render_template(inventory))


main()
