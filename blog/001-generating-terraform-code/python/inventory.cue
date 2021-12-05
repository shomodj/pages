vars: {
	public_ip: "188.252.196.255/32"
	subnet_a:  "172.31.16.0/20"
	subnet_b:  "172.31.0.0/20"
	subnet_c:  "172.31.32.0/20"
}

nacl: bastion: ingress: [
	"from \(vars.public_ip) to any port 22 proto tcp",
	"from \(vars.subnet_a)  to any port 1024:65535 proto tcp",
	"deleted",
	"from \(vars.subnet_b)  to any port 1024:65535 proto tcp",
	"from \(vars.subnet_c)  to any port 1024:65535 proto tcp",
]

nacl: bastion: egress: [
	"from any to \(vars.public_ip) port 1024:65535 proto tcp",
	"deleted",
	"from any to \(vars.subnet_a)  port 22 proto tcp",
	"from any to \(vars.subnet_b)  port 22 proto tcp",
	"from any to \(vars.subnet_c)  port 22 proto tcp",
]
