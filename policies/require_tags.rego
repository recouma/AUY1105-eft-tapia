# ============================================================
# Política OPA: Requerir tags obligatorios
# ============================================================
# Verifica que todos los recursos creados incluyan los tags
# Project y Environment, asegurando trazabilidad y gobernanza.
# Alineado con: AWS Well-Architected — Tagging Strategy
# ============================================================

package terraform.security

import rego.v1

required_tags := {"Project", "Environment"}

# Regla: denegar instancias EC2 sin tags obligatorios
deny contains msg if {
	some resource in input.resource_changes
	resource.type == "aws_instance"
	tags := object.get(resource.change.after, "tags", {})
	some required_tag in required_tags
	not required_tag in object.keys(tags)
	msg := sprintf(
		"DENY: El recurso '%s' no tiene el tag obligatorio '%s'.",
		[resource.address, required_tag],
	)
}
