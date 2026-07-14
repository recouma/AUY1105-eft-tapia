# Changelog

Todos los cambios notables en este proyecto se documentan en este archivo.
El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y sigue [Versionado Semántico](https://semver.org/lang/es/).

## [3.0.0] - 2026-07-14

### Added
- Consolidado final integrando EP1, EP2 y EP3
- Política OPA: cifrado EBS obligatorio (require_encryption.rego)
- Política OPA: tags obligatorios Project/Environment (require_tags.rego)
- 5 escenarios de prueba OPA (conforme, SSH, tipo, cifrado, tags)
- Etapa 5 del pipeline: terraform plan
- Informe técnico consolidado (docs/informe.md)
- Módulo S3 con versionado, cifrado y bloqueo de acceso público

### Changed
- Pipeline CI/CD ampliado de 4 a 5 etapas
- Políticas OPA ampliadas de 2 a 4, alineadas con CIS AWS Benchmark
- Escenarios de prueba ampliados de 3 a 5
- Documentación mejorada con tablas de variables/outputs por módulo
- Variables con bloques de validación en todos los módulos

## [2.1.0] - 2026-06-XX

### Added
- Gestión avanzada del estado: terraform import, refresh, taint, state rm
- Técnicas de optimización: locals, merge(), format(), condicionales
- Variables con validation blocks

### Changed
- Refactorización del código para mayor legibilidad

## [2.0.0] - 2026-05-XX

### Added
- Modularización del código en 3 módulos independientes (VPC, EC2, S3)
- Repositorios separados por módulo con versionado semántico
- Carpeta examples/ con ejemplos funcionales por módulo
- versions.tf en cada módulo

### Changed
- **BREAKING**: Arquitectura monolítica refactorizada a módulos — requiere terraform state mv
- README actualizado con documentación por módulo
- CHANGELOG con formato Keep a Changelog

## [1.0.0] - 2026-04-XX

### Added
- Infraestructura base: VPC (10.1.0.0/16), subnets, Security Groups, EC2 (t2.micro)
- Pipeline CI/CD con GitHub Actions: TFLint, Checkov, terraform validate
- 2 políticas OPA: denegar SSH público, solo t2.micro
- 3 escenarios de prueba OPA
- Flujo de PRs con revisiones cruzadas
- Documentación inicial: README.md, CHANGELOG.md, .gitignore
