# ============================================================
# Política OPA: Requerir cifrado en volúmenes EBS
# ============================================================
# Verifica que todas las instancias EC2 tengan sus volúmenes
# raíz cifrados, cumpliendo con estándares de protección de
# datos en reposo.
# Alineado con: CIS AWS Benchmark 2.2.1 — EBS Encryption
# ============================================================

package terraform.security

import rego.v1

# Regla: denegar si el volumen raíz no está cifrado
deny contains msg if {
	some resource in input.resource_changes
	resource.type == "aws_instance"
	some rbd in resource.change.after.root_block_device
	not rbd.encrypted
	msg := sprintf(
		"DENY: La instancia '%s' tiene el volumen raíz sin cifrar. Habilite encrypted = true.",
		[resource.address],
	)
}
