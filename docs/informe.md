# Informe Técnico — Evaluación Final Transversal

**Asignatura**: AUY1105 — Infraestructura como Código II
**Estudiante**: Daniel Tapia Sobarzo (@recouma)
**Fecha**: Julio 2026

---

## 1. Introducción

Este informe presenta la solución consolidada desarrollada a lo largo del semestre para la asignatura Infraestructura como Código II. El proyecto aborda el diseño e implementación de infraestructura en la nube AWS utilizando Terraform, integrando prácticas modernas de automatización CI/CD, análisis de calidad de código, políticas de seguridad como código y modularización.

La solución consolida el trabajo realizado en las tres evaluaciones parciales, incorporando mejoras y correcciones identificadas durante el proceso de aprendizaje, resultando en un proyecto integral que demuestra competencia en el ciclo completo de Infraestructura como Código.

---

## 2. Alcance

### Objetivos

1. Desplegar infraestructura AWS (VPC, EC2, S3) mediante módulos Terraform reutilizables
2. Implementar un pipeline CI/CD con GitHub Actions que automatice el análisis de calidad y seguridad
3. Definir y validar políticas de seguridad mediante Open Policy Agent (OPA)
4. Aplicar técnicas de optimización para mejorar la legibilidad y mantenibilidad del código
5. Documentar exhaustivamente la solución, sus componentes y su uso

### Recursos necesarios

- Cuenta AWS Academy Learner Lab (región us-east-1)
- Repositorio GitHub con GitHub Actions habilitado
- Herramientas: Terraform >= 1.6, TFLint, Checkov, OPA

### Criterios de éxito

- Pipeline CI/CD ejecutándose correctamente en PRs hacia main
- Todas las políticas OPA validando correctamente (5/5 escenarios)
- Código modular con variables parametrizadas y outputs definidos
- Documentación completa con README, CHANGELOG y ejemplos

### Fundamento en evaluaciones anteriores

| Parcial | Aporte al consolidado |
|---------|----------------------|
| **P1** (80/100) | Pipeline CI/CD base (TFLint + Checkov + Validate + OPA), políticas de seguridad, flujo de PRs |
| **P2** (86.6/100) | Modularización del código en repositorios independientes (VPC, EC2, S3), versionado semántico |
| **EP3** (20.4/100) | Uso de funciones avanzadas de Terraform: `format()`, `merge()`, expresiones condicionales, validaciones |

---

## 3. Diseño de la solución

### 3.1 Componentes de infraestructura

La solución despliega tres capas de recursos en AWS:

**Capa de Red (módulo VPC)**:
Se crea una VPC con CIDR 10.1.0.0/16 que contiene dos subredes — una pública (10.1.1.0/24) con Internet Gateway para conectividad externa, y una privada (10.1.2.0/24) donde se aloja la instancia EC2. El Security Group restringe el acceso SSH exclusivamente al rango de la VPC (10.1.0.0/16), cumpliendo con CIS AWS Benchmark 5.2.

**Capa de Cómputo (módulo EC2)**:
Se despliega una instancia t2.micro con Ubuntu 24.04 LTS en la subred privada. La instancia implementa medidas de seguridad avanzadas: cifrado de volumen EBS (AES-256), IMDSv2 obligatorio para protección contra SSRF, y tags obligatorios para trazabilidad.

**Capa de Almacenamiento (módulo S3)**:
Se crea un bucket S3 con tres capas de protección: bloqueo total de acceso público, versionado habilitado para recuperación ante borrado accidental, y cifrado server-side con AES-256.

### 3.2 Pipeline CI/CD

El pipeline se implementa con GitHub Actions y se activa exclusivamente en Pull Requests hacia la rama main, asegurando que todo cambio pase por revisión antes de integrarse. Las cinco etapas son secuenciales (cada una depende del éxito de la anterior):

1. **TFLint**: Detecta errores de estilo, variables no usadas, y desviaciones de mejores prácticas específicas del proveedor AWS.
2. **Checkov**: Escanea el código contra más de 1000 checks de seguridad de Bridgecrew/Prisma Cloud, verificando compliance con CIS, SOC2, HIPAA.
3. **terraform validate**: Verifica la coherencia sintáctica y la validez de las referencias entre recursos.
4. **OPA**: Evalúa 5 escenarios de prueba contra las políticas Rego, verificando que configuraciones no conformes sean correctamente denegadas.

### 3.3 Políticas de seguridad (OPA)

Se implementaron 4 políticas en Rego v1, cada una alineada con estándares reconocidos:

| Política | Propósito | Estándar |
|----------|-----------|----------|
| `deny_public_ssh` | Impedir acceso SSH desde 0.0.0.0/0 | CIS AWS 5.2 |
| `only_t2_micro` | Controlar tipos de instancia permitidos | Gobernanza de costos |
| `require_encryption` | Exigir cifrado en volúmenes EBS | CIS AWS 2.2.1 |
| `require_tags` | Exigir tags Project y Environment | AWS Well-Architected |

Se diseñaron 5 fixtures de prueba que cubren: un escenario conforme (debe pasar) y cuatro escenarios de violación (deben ser denegados), validando exhaustivamente la efectividad de las políticas.

### 3.4 Técnicas de optimización

- **Variables con `validation`**: Previenen errores en tiempo de `plan` en lugar de en `apply`
- **`locals`**: Centralizan tags comunes y prefijos, eliminando duplicación
- **`merge()` + condicionales**: Composición dinámica de tags según ambiente
- **`format()`**: Nombres de recursos estandarizados y legibles
- **Estructura modular**: Cada módulo tiene responsabilidad única (SRP)
- **`terraform fmt -check`** en CI: Garantiza formateo consistente

---

## 4. Diagrama de la arquitectura

```
                    ┌──────────────────────────────────────┐
                    │          GitHub Repository            │
                    │      AUY1105-eft-tapia                │
                    └──────────┬───────────────────────────┘
                               │ Pull Request
                    ┌──────────▼───────────────────────────┐
                    │        GitHub Actions CI/CD           │
                    │                                      │
                    │  ┌─────┐ ┌───────┐ ┌────┐ ┌───┐     │
                    │  │TFLint│→│Checkov│→│ TF │→│OPA│     │
                    │  └─────┘ └───────┘ │Val.│ └───┘     │
                    │                    └────┘            │
                    └──────────┬───────────────────────────┘
                               │ ✅ Aprobado
                    ┌──────────▼───────────────────────────┐
                    │            AWS Cloud                  │
                    │                                      │
                    │  ┌────────────────────────────────┐   │
                    │  │       VPC (10.1.0.0/16)        │   │
                    │  │                                │   │
                    │  │  ┌──────────┐  ┌────────────┐  │   │
                    │  │  │ Pública  │  │  Privada   │  │   │
                    │  │  │ 10.1.1.0 │  │  10.1.2.0  │  │   │
                    │  │  │   /24    │  │    /24     │  │   │
                    │  │  └──────────┘  │            │  │   │
                    │  │       │        │ ┌────────┐ │  │   │
                    │  │    ┌──┴──┐     │ │  EC2   │ │  │   │
                    │  │    │ IGW │     │ │t2.micro│ │  │   │
                    │  │    └─────┘     │ └────────┘ │  │   │
                    │  │               └────────────┘  │   │
                    │  └────────────────────────────────┘   │
                    │                                      │
                    │  ┌────────────────────────────────┐   │
                    │  │  S3 Bucket (cifrado, privado)  │   │
                    │  └────────────────────────────────┘   │
                    └──────────────────────────────────────┘
```

---

## 5. Conclusiones

La solución presentada aborda de manera integral los desafíos planteados en las tres evaluaciones parciales:

**Del Parcial 1** se consolida el pipeline CI/CD de 5 etapas y las políticas OPA, ampliándolas de 2 a 4 políticas e incrementando los escenarios de prueba de 3 a 5. Esto responde directamente a la retroalimentación recibida (60% en IL2.1) donde se identificaron lagunas en la cobertura de políticas de seguridad.

**Del Parcial 2** se mantiene la estructura modular con separación clara de responsabilidades (VPC, EC2, S3), cada módulo con su propio `main.tf`, `variables.tf`, `outputs.tf` y `versions.tf`. Se mejoró la documentación incorporando tablas descriptivas de variables y outputs, y ejemplos de uso.

**Del Parcial 3** se integran las técnicas de optimización: variables con validación, uso de `locals` para centralizar configuración, funciones `merge()` y `format()` para composición dinámica, y expresiones condicionales para adaptación por ambiente.

El proyecto cumple con los estándares de seguridad (CIS AWS Benchmarks), calidad (análisis estático con TFLint y Checkov), y gobernanza (políticas OPA) requeridos por la asignatura, demostrando un flujo de trabajo GitOps completo desde el código hasta la validación automatizada.

---

## 6. Anexos

- **Repositorio GitHub**: https://github.com/recouma/AUY1105-eft-tapia
- **Pipeline CI/CD**: ver pestaña Actions del repositorio
- **Evidencias**: carpeta `evidencias/` del repositorio
