# ============================================================
# Política OPA: Denegar acceso SSH público (0.0.0.0/0)
# ============================================================
# Verifica que ningún Security Group permita SSH (puerto 22)
# desde 0.0.0.0/0, protegiendo las instancias EC2 de acceso
# no autorizado desde Internet.
# Alineado con: CIS AWS Benchmark 5.2 — Restrict SSH access
# ============================================================

package terraform.security

import rego.v1

# Regla: denegar si existe un SG con SSH abierto a 0.0.0.0/0
deny contains msg if {
	some resource in input.resource_changes
	resource.type == "aws_security_group"
	some ingress in resource.change.after.ingress
	ingress.from_port <= 22
	ingress.to_port >= 22
	some cidr in ingress.cidr_blocks
	cidr == "0.0.0.0/0"
	msg := sprintf(
		"DENY: El Security Group '%s' permite SSH (puerto 22) desde 0.0.0.0/0. Restrinja el acceso a un CIDR específico.",
		[resource.address],
	)
}
