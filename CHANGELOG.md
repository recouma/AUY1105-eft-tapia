# Changelog

Todos los cambios notables en este proyecto se documentan en este archivo.
El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y sigue [Versionado Semántico](https://semver.org/lang/es/).

## [1.0.0] - 2026-07-14

### Added
- Módulo VPC: VPC, subredes pública/privada, IGW, route tables, security groups
- Módulo EC2: instancia t2.micro con Ubuntu 24.04 LTS, cifrado EBS, IMDSv2
- Módulo S3: bucket con versionado, cifrado SSE-S3, bloqueo de acceso público
- Pipeline CI/CD con GitHub Actions (TFLint → Checkov → Validate → OPA)
- 4 políticas OPA: SSH público, tipo instancia, cifrado EBS, tags obligatorios
- 5 escenarios de prueba para validación de políticas
- Documentación completa: README, CHANGELOG, examples/
- Informe técnico consolidado (docs/informe.md)

## [0.2.0] - 2026-07-14

### Added
- Políticas OPA adicionales (cifrado y tags)
- Tests OPA para los 5 escenarios
- Integración de OPA como etapa 4 del pipeline

### Changed
- Refactorización de políticas Rego a sintaxis v1

## [0.1.0] - 2026-07-14

### Added
- Estructura inicial del proyecto
- Módulos base (vpc, ec2, s3) con variables, outputs y versions
- Configuración del proveedor AWS ~> 5.0
- Pipeline CI/CD básico (TFLint + Checkov + terraform validate)
- Archivo .gitignore y CHANGELOG.md
