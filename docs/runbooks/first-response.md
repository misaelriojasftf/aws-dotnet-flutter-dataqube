# First Response

## Propósito

Definir los primeros pasos ante incidentes en una arquitectura con Flutter, API Gateway, Lambda .NET, RDS MySQL, Secrets Manager, CloudWatch y despliegues con GitHub Actions.

## Objetivos del primer response

- Confirmar si el incidente sigue activo
- Medir el impacto
- Contener el problema sin empeorarlo
- Reunir evidencias útiles para diagnóstico
- Escalar con contexto claro si hace falta

## Tipos de incidente esperables

- La app Flutter no puede invocar la API
- API Gateway devuelve 4xx o 5xx
- Lambda falla por excepción, timeout o permisos
- RDS rechaza conexiones o consultas
- Secrets Manager no entrega configuración válida
- CloudWatch muestra errores o métricas anómalas
- Un workflow de GitHub Actions falla en análisis, build o deploy

## Primeros pasos

### 1. Confirmar alcance

Responder rápidamente:

- ¿Afecta a todos los usuarios o a un entorno concreto?
- ¿Es `dev`, `stg` o `prod`?
- ¿El fallo empezó tras un despliegue?
- ¿Es un error funcional, de rendimiento, de permisos o de red?

### 2. Recolectar señales básicas

Revisar:

- Hora aproximada de inicio
- Endpoint afectado
- Método HTTP afectado
- Mensaje de error visible desde cliente o pipeline
- `RequestId` o identificador de ejecución si existe

### 3. Revisar CloudWatch

Validar en este orden:

- Logs de Lambda
- Métricas personalizadas
- Métricas de errores y duración
- Cambios bruscos en volumen o fallos

Buscar especialmente:

- Excepciones no controladas
- Errores de conexión a base de datos
- Errores de permisos IAM
- Secretos faltantes o inválidos
- Timeouts

### 4. Revisar el último cambio

Confirmar:

- Último commit desplegado
- Último workflow exitoso o fallido
- Cambios en `template.yaml`, `samconfig.toml`, configuración de API o credenciales
- Cambios en variables de entorno o secretos

### 5. Clasificar la causa probable

Clasificación rápida útil:

- Aplicación: bug de lógica o validación
- Configuración: variables, endpoint, stage, secret o región
- Seguridad: IAM, Cognito, policy, authorization
- Red: VPC, Security Groups, acceso a RDS
- Operación: timeout, saturación, dependencia no disponible
- Pipeline: error de build, test, empaquetado o deploy

## Checklist de diagnóstico por servicio

### API Gateway

- Confirmar ruta y método correctos
- Validar stage correcto
- Revisar integración con Lambda
- Revisar códigos 4xx y 5xx
- Confirmar si la autorización esperada coincide con la configurada

### Lambda

- Revisar logs de ejecución
- Confirmar variables de entorno
- Validar timeout y memoria
- Revisar excepciones de deserialización, validación y acceso a datos
- Confirmar permisos para CloudWatch y Secrets Manager

### RDS MySQL

- Confirmar que la instancia esté disponible
- Revisar conectividad desde Lambda
- Verificar host, puerto, usuario, base de datos
- Revisar errores SQL o problemas de esquema
- Confirmar reglas de red y Security Groups

### Secrets Manager

- Confirmar existencia del secreto
- Revisar formato del JSON del secreto
- Validar permisos `secretsmanager:GetSecretValue`
- Verificar que el nombre del secreto coincida con la configuración desplegada

### CloudWatch

- Revisar logs del backend
- Revisar métricas personalizadas
- Revisar alarmas si existen
- Correlacionar eventos por tiempo y `RequestId`

### IAM y seguridad

- Verificar si cambió una policy o un role
- Revisar permisos de Lambda para CloudWatch y Secrets Manager
- Confirmar si el acceso desde cliente debe pasar por Cognito o no

### VPC y Security Groups

- Confirmar si Lambda está dentro o fuera de la VPC
- Verificar subredes y rutas si aplica
- Revisar reglas de entrada y salida
- Confirmar apertura de puerto 3306 entre origen y destino

### GitHub Actions

- Revisar logs del job fallido
- Confirmar secretos requeridos
- Revisar si el workflow corre en la rama esperada
- Confirmar que el fallo sea de análisis, build, test, AWS auth o deploy

## Acciones de contención

Aplicar solo si reducen riesgo:

- Pausar despliegues nuevos
- Revertir al último despliegue estable si el incidente empezó tras un cambio
- Deshabilitar temporalmente una funcionalidad no crítica
- Redirigir el análisis a un entorno no productivo si el fallo es de configuración

## Qué no hacer en first response

- No modificar varias cosas a la vez sin registrar el cambio
- No borrar logs ni evidencias
- No asumir que el error está en el código sin revisar red, permisos y configuración
- No compartir secretos en tickets, chats o capturas

## Información mínima para escalar

Antes de escalar, documentar:

- Hora de inicio
- Entorno afectado
- Endpoint o flujo impactado
- Síntoma observado
- Severidad estimada
- Evidencia encontrada en CloudWatch o CI/CD
- Último cambio relevante
- Hipótesis principal
- Acción ya tomada

## Guía rápida por síntoma

### Si la app móvil falla al llamar la API

- Confirmar endpoint, región y stage
- Revisar si el backend responde con 4xx o 5xx
- Verificar autorización esperada
- Buscar errores correlacionados en CloudWatch

### Si Lambda devuelve 500

- Revisar excepción exacta en logs
- Confirmar acceso a Secrets Manager
- Confirmar conectividad y credenciales de RDS
- Revisar payload de entrada y deserialización

### Si la conexión a RDS falla

- Confirmar secreto y formato
- Validar host y puerto
- Revisar red, VPC y Security Groups
- Verificar disponibilidad de la base de datos

### Si el deploy falla en GitHub Actions

- Revisar autenticación AWS
- Revisar secretos del repositorio
- Confirmar `sam build` y `sam deploy`
- Validar parámetros y región

## Cierre del incidente

Una vez mitigado:

- Registrar causa raíz preliminar
- Documentar aprendizaje
- Crear acciones preventivas
- Proponer mejoras en tests, alarmas, permisos o despliegue
