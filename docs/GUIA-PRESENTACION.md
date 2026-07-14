# Guía de Presentación — EFT AUY1105

## Estructura: 5 min exposición + 5 min preguntas

---

## SPEECH (5 minutos)

### Minuto 0-1: Introducción y contexto
> "Buenas, mi nombre es Daniel Tapia. Mi proyecto consolida el trabajo de los tres parciales en una solución completa de infraestructura en AWS usando Terraform. El proyecto tiene cuatro pilares: infraestructura modular, pipeline CI/CD automatizado, políticas de seguridad como código, y técnicas de optimización."

### Minuto 1-2: Mostrar la infraestructura (compartir pantalla → repo GitHub)
> "La infraestructura se organiza en tres módulos independientes. El módulo VPC crea la red con CIDR 10.1.0.0/16, con una subred pública y una privada. El módulo EC2 despliega una instancia t2.micro con Ubuntu 24.04, volumen cifrado e IMDSv2 obligatorio. Y el módulo S3 crea un bucket con acceso público bloqueado, versionado y cifrado AES-256."

**DEMO**: Mostrar `main.tf` raíz → cómo llama a los 3 módulos → mostrar un módulo por dentro (ej: `modules/vpc/main.tf`)

### Minuto 2-3: Pipeline CI/CD
> "El pipeline se activa automáticamente en cada Pull Request hacia main. Tiene cuatro etapas secuenciales: primero TFLint para análisis estático, luego Checkov para análisis de seguridad, después terraform validate para validación sintáctica, y finalmente OPA para evaluación de políticas personalizadas."

**DEMO**: Ir a la pestaña Actions → mostrar un workflow ejecutado en verde → abrir los logs de cada etapa

### Minuto 3-4: Políticas OPA y pruebas
> "Implementé cuatro políticas OPA en Rego v1. La primera deniega SSH público desde 0.0.0.0/0, alineada con CIS AWS Benchmark. La segunda restringe el tipo de instancia a t2.micro. La tercera exige cifrado en volúmenes EBS. Y la cuarta requiere tags obligatorios de Project y Environment."
>
> "Para validar estas políticas, diseñé cinco escenarios de prueba: uno conforme que debe pasar, y cuatro con violaciones específicas que deben ser denegados. Todos se ejecutan automáticamente en el pipeline."

**DEMO**: Mostrar un archivo `.rego` → mostrar un test JSON → mostrar los resultados en los logs de GitHub Actions

### Minuto 4-5: Optimización y cierre
> "Apliqué varias técnicas de optimización: variables con bloques de validación para prevenir errores temprano, locals para centralizar tags comunes usando merge(), expresiones condicionales para adaptación por ambiente, y format() para nombres estandarizados."
>
> "En resumen, el proyecto demuestra un flujo GitOps completo: el código pasa por revisión en PR, se analiza automáticamente en cuatro etapas, y solo se integra si cumple con todos los estándares de calidad y seguridad."

---

## PREGUNTAS FRECUENTES Y RESPUESTAS

### Sobre herramientas de análisis estático (IE1.2.2 — 20%)

**P: ¿Qué es TFLint y para qué sirve?**
> "TFLint es un linter especializado para Terraform. Hace análisis estático del código para detectar errores antes de ejecutar plan o apply. Encuentra cosas como tipos de instancia inválidos, variables sin usar, o desviaciones de las mejores prácticas del proveedor AWS. Es la primera línea de defensa en nuestro pipeline."

**P: ¿Qué es Checkov y qué diferencia tiene con TFLint?**
> "Checkov es una herramienta de Bridgecrew, ahora parte de Prisma Cloud. Se enfoca específicamente en seguridad, no en estilo de código. Escanea el código Terraform contra más de 1000 checks predefinidos que cubren estándares como CIS, SOC2 y HIPAA. Por ejemplo, verifica que los buckets S3 no tengan acceso público, que los volúmenes EBS estén cifrados, y que los Security Groups no tengan puertos abiertos indebidamente."

**P: ¿Qué hace terraform validate?**
> "Terraform validate verifica la coherencia sintáctica del código. Comprueba que las referencias entre recursos sean válidas, que los tipos de variables coincidan, y que la estructura del código HCL sea correcta. No se conecta a AWS ni verifica el estado real de la infraestructura."

**P: ¿Por qué el pipeline es secuencial y no paralelo?**
> "Es secuencial porque cada etapa filtra problemas de distinta naturaleza. No tiene sentido correr Checkov si TFLint ya encontró errores de sintaxis. Cada etapa depende de que la anterior pase. Es un filtro progresivo: primero estilo, luego seguridad, luego sintaxis, luego políticas."

### Sobre políticas de seguridad (IE2.1.2 — 10%)

**P: ¿Qué es OPA y por qué se usa?**
> "Open Policy Agent es un motor de políticas de propósito general. Lo usamos para definir reglas de seguridad como código, escritas en lenguaje Rego. La ventaja es que las políticas se versionan junto con la infraestructura, se prueban automáticamente, y se evalúan antes de aplicar cualquier cambio. Es Policy as Code."

**P: ¿Cómo funciona la evaluación de políticas OPA con Terraform?**
> "El flujo es: terraform plan genera un JSON con los cambios propuestos. Ese JSON se pasa como input a OPA junto con los archivos Rego. OPA evalúa las reglas y devuelve un conjunto de denegaciones. Si el conjunto está vacío, el plan es conforme. Si tiene mensajes, significa que hay violaciones."

**P: ¿Por qué SSH público es un riesgo?**
> "Porque expone el puerto 22 a todo Internet. Cualquier persona podría intentar ataques de fuerza bruta contra la instancia. Por eso la política restringe SSH a un CIDR específico, en nuestro caso el rango de la VPC 10.1.0.0/16."

**P: ¿Qué estándares cubren tus políticas?**
> "La política de SSH se alinea con CIS AWS Benchmark sección 5.2 que dice que SSH no debe estar abierto a 0.0.0.0/0. La política de cifrado se alinea con CIS 2.2.1 sobre cifrado de EBS. La de tags sigue la guía de AWS Well-Architected Framework sobre estrategia de etiquetado."

### Sobre módulos (IE3.1.2 — 20%)

**P: ¿Por qué usar módulos en Terraform?**
> "Los módulos permiten desacoplar la infraestructura en componentes reutilizables. En vez de tener todo en un solo archivo, separamos la red, el cómputo y el almacenamiento. Cada módulo tiene sus propias variables, outputs y versiones. Esto permite reutilizarlos en otros proyectos, testearlos de forma independiente, y aplicar el principio de responsabilidad única."

**P: ¿Cuál es la estructura estándar de un módulo Terraform?**
> "Un módulo debe tener al mínimo cuatro archivos: main.tf con la definición de los recursos, variables.tf con las variables de entrada y sus descripciones, outputs.tf con los valores que expone el módulo, y versions.tf con las versiones requeridas de Terraform y los proveedores."

**P: ¿Cómo se pasan datos entre módulos?**
> "A través de outputs e inputs. Por ejemplo, el módulo VPC expone el output private_subnet_id, y el módulo EC2 lo recibe como input en su variable subnet_id. En el root module, se conectan así: subnet_id = module.vpc.private_subnet_id. Es como conectar piezas de Lego."

**P: ¿Qué diferencia hay entre un módulo local y uno remoto?**
> "Un módulo local está en una carpeta del mismo repositorio, se referencia con source = ./modules/vpc. Un módulo remoto está en otro repositorio de GitHub o en Terraform Registry, y se referencia con la URL del repo y un tag de versión. En el Parcial 2 usamos módulos remotos en repos separados."

### Sobre documentación (IE3.2.2 — 10%)

**P: ¿Qué debe incluir la documentación de un módulo?**
> "Debe incluir: el propósito del módulo, una tabla con todas las variables describiendo tipo, descripción y valor por defecto, una tabla con los outputs, las dependencias o requisitos previos, y ejemplos funcionales de uso. Todo esto en el README.md del módulo."

**P: ¿Para qué sirve el CHANGELOG?**
> "El CHANGELOG registra todos los cambios entre versiones, clasificados como Added, Changed, Fixed o Removed. Permite a cualquier usuario del módulo saber qué cambió entre la versión 0.1.0 y la 1.0.0, y si necesita adaptar su código al actualizar."

### Sobre versionado semántico (IE3.3.2 — 10%)

**P: ¿Qué es el versionado semántico?**
> "Es un esquema de tres números: MAJOR.MINOR.PATCH. MAJOR sube cuando hay cambios incompatibles, MINOR cuando se agregan funcionalidades compatibles, y PATCH para correcciones de bugs. Por ejemplo, si agrego una nueva variable opcional al módulo, subo el MINOR. Si cambio el nombre de una variable existente, subo el MAJOR porque rompe la compatibilidad."

**P: ¿Cómo implementaste el versionado en GitHub?**
> "Usando git tags y GitHub Releases. Cada versión tiene un tag como v1.0.0 asociado a un commit específico, y un Release en GitHub con la descripción de los cambios. El CHANGELOG.md documenta el historial completo de versiones."

---

## CHECKLIST PRE-PRESENTACIÓN

- [ ] Repo público y accesible
- [ ] Pipeline CI/CD ejecutado y en verde (al menos 1 PR mergeado)
- [ ] Al menos 2 PRs con comentarios de revisión
- [ ] terraform init + plan funciona en Learner Lab
- [ ] OPA instalado y tests pasando localmente
- [ ] Tener abiertos en el navegador: repo, Actions, un PR con review
- [ ] Informe subido en docs/informe.md
- [ ] Saber explicar cada archivo del proyecto
