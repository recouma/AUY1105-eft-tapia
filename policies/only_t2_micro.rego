# ============================================================
# Política OPA: Solo permitir instancias EC2 tipo t2.micro
# ============================================================
# Garantiza que todas las instancias EC2 creadas sean de tipo
# t2.micro, controlando costos y cumpliendo con las
# restricciones del Learner Lab de AWS Academy.
# Alineado con: Control de costos y gobernanza de recursos
# ============================================================

package terraform.security

import rego.v1

# Tipos de instancia permitidos
allowed_instance_types := {"t2.micro"}

# Regla: denegar si el tipo de instancia no está permitido
deny contains msg if {
	some resource in input.resource_changes
	resource.type == "aws_instance"
	instance_type := resource.change.after.instance_type
	not instance_type in allowed_instance_types
	msg := sprintf(
		"DENY: La instancia '%s' usa tipo '%s'. Solo se permite: %v",
		[resource.address, instance_type, allowed_instance_types],
	)
}
