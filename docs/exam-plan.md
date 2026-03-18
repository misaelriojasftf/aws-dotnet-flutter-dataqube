# Plan de Estudio

## Objetivo

Preparar una evaluación técnica enfocada en AWS aplicado a un proyecto con Flutter, .NET, SAM y CI/CD, reforzando tanto conceptos como resolución de incidentes y lectura de arquitectura.

## Alcance

El estudio se centra en los servicios y patrones observados en este repositorio:

- AWS SAM
- IAM
- Cognito
- RDS MySQL
- API Gateway
- S3
- VPC
- Security Groups
- Secrets Manager
- CloudWatch
- Bonus: GitHub Actions para CI/CD
- Integración con Flutter y .NET

## Estrategia de preparación

- Bloque principal: practicar entre 70 y 100 preguntas de opción múltiple.
- Si el tiempo de sesión debe mantenerse en 2 horas: resolver 30 a 40 preguntas en vivo y dejar el resto como tarea.
- Alternar teoría con labs cortos para consolidar conceptos.
- Reforzar las preguntas donde la justificación importe más que memorizar el dato.
- Priorizar trazabilidad de extremo a extremo:
  Flutter -> API Gateway -> Lambda .NET -> RDS/Secrets Manager -> CloudWatch -> despliegue con SAM/GitHub Actions

## 3 Temas Débiles

### 1. Seguridad e identidad en AWS

Se requiere reforzar:

- Diferencia entre autenticación y autorización
- Uso de IAM frente a Cognito
- Principio de mínimo privilegio
- Riesgos de usar `authorizationType: NONE` en APIs
- Manejo seguro de secretos con Secrets Manager

Por qué importa:

- Es una de las áreas más preguntadas en entrevistas y exámenes.
- Afecta directamente el diseño de APIs móviles y serverless.
- Es fácil confundir IAM roles, policies, Cognito User Pools y acceso de aplicaciones clientes.

### 2. Redes y conectividad para workloads serverless

Se requiere reforzar:

- Cuándo una Lambda necesita estar en una VPC
- Diferencia entre subredes públicas y privadas
- Qué controlan los Security Groups
- Conectividad entre Lambda y RDS MySQL
- Impacto de la red sobre latencia, acceso a internet y resolución de incidentes

Por qué importa:

- Muchos fallos reales no son de código, sino de red o permisos.
- Lambda + RDS suele ser un punto clásico de preguntas técnicas.

### 3. Observabilidad y respuesta operativa

Se requiere reforzar:

- Diferencia entre logs, métricas y alarmas
- Lectura de logs estructurados en CloudWatch
- Uso de métricas personalizadas
- Correlación por `RequestId`
- Primer triage ante errores 4xx, 5xx, timeouts o fallos de despliegue

Por qué importa:

- En este repo CloudWatch tiene un papel importante tanto en backend como en CI.
- Es clave para explicar cómo detectar, entender y escalar incidentes.

## 2 Labs Sugeridos 

### Lab 1. Flujo serverless completo con SAM

Objetivo:

- Repetir el despliegue de la Lambda .NET con AWS SAM.
- Validar variables de entorno, permisos IAM, Secrets Manager y rutas de API Gateway.

Pasos sugeridos:

- Revisar `template.yaml` y `samconfig.toml`
- Ejecutar `sam build`
- Ejecutar despliegue guiado o con configuración
- Validar endpoints `POST /adjustments` y `GET /stores/{storeId}/adjustments`
- Confirmar logs y métricas en CloudWatch

Servicios reforzados:

- SAM
- Lambda
- API Gateway
- IAM
- Secrets Manager
- CloudWatch

### Lab 2. Integración móvil con backend AWS

Objetivo:

- Repetir la integración del cliente Flutter con la API expuesta por AWS.
- Revisar configuración de Amplify/API, errores de llamada y comportamiento de la app.

Pasos sugeridos:

- Revisar configuración de API en Flutter
- Confirmar endpoint, región y tipo de autorización
- Probar llamada desde la app
- Simular error de backend y verificar cómo se muestra al usuario
- Analizar qué mejoraría para producción

Servicios reforzados:

- API Gateway
- Cognito
- IAM
- CloudWatch
- Bonus de CI/CD para validación automática

## Plan de trabajo sugerido

### Sesión 1

- Repasar IAM, Cognito y Secrets Manager
- Resolver preguntas 1 a 20
- Repetir Lab 1 en modo guiado

### Sesión 2

- Repasar API Gateway, Lambda, SAM y CloudWatch
- Resolver preguntas 21 a 40
- Hacer mini resumen de errores comunes y señales de diagnóstico

### Sesión 3

- Repasar RDS, VPC y Security Groups
- Resolver preguntas 41 a 60
- Repetir Lab 2 con foco en integración móvil

### Sesión 4

- Repasar S3 y CI/CD con GitHub Actions
- Resolver preguntas 61 a 70
- Revisar respuestas comentadas de las primeras 30

## Criterios de preparación

Se considera una buena preparación cuando la persona puede:

- Explicar el flujo de una petición desde Flutter hasta RDS
- Justificar por qué usar Secrets Manager en lugar de credenciales hardcodeadas
- Describir cómo diagnosticar un incidente con CloudWatch
- Diferenciar el rol de IAM, Cognito, Security Groups y VPC
- Explicar qué hace SAM y cómo participa GitHub Actions en CI/CD

## Entregables relacionados

- `docs/runbooks/first-response.md`
- `docs/runbooks/exam-practice-questions.md`
