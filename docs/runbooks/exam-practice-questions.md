# Exam Practice Questions


## Preguntas

## P1. ¿Cuál es la política IAM mínima para que una Lambda escriba en DynamoDB?

- [ ] A. `dynamodb:*` sobre todos los recursos de la cuenta
- [ ] B. `dynamodb:PutItem` sobre la tabla específica
- [ ] C. `lambda:InvokeFunction` sobre la propia Lambda
- [ ] D. `cloudwatch:PutMetricData` sobre cualquier namespace

## P2. ¿Qué es un trust relationship en IAM?

- [ ] A. La lista de buckets S3 que un usuario puede leer
- [ ] B. El documento que define qué principal o servicio puede asumir un rol
- [ ] C. Una política administrada por AWS para DynamoDB
- [ ] D. Un tipo de métrica de seguridad en CloudWatch

## P3. ¿Cuál es el timeout máximo de API Gateway?

- [ ] A. 15 segundos
- [ ] B. 20 segundos
- [ ] C. 29 segundos
- [ ] D. 60 segundos

## P4. ¿Cuál es el timeout máximo de Lambda?

- [ ] A. 5 minutos
- [ ] B. 10 minutos
- [ ] C. 15 minutos
- [ ] D. 30 minutos

## P5. ¿Qué es cold start en Lambda?

- [ ] A. El borrado automático de logs tras una invocación
- [ ] B. La latencia adicional de una invocación inicial al levantar el entorno de ejecución
- [ ] C. Una política IAM temporal para funciones inactivas
- [ ] D. El tiempo que tarda RDS en aceptar conexiones TLS

## P6. ¿Cuánto dura una presigned URL por defecto?

- [ ] A. Siempre 5 minutos y no puede cambiarse
- [ ] B. Depende del SDK o implementación; comúnmente se configura en 1 hora
- [ ] C. Siempre 24 horas exactas
- [ ] D. Nunca expira

## P7. En DynamoDB, ¿qué es la partition key?

- [ ] A. La clave que determina cómo se distribuyen y localizan los ítems
- [ ] B. El nombre del índice secundario global
- [ ] C. El campo usado para cifrar la tabla
- [ ] D. El identificador del role IAM de la aplicación

## P8. ¿Cuál es el máximo tiempo de transacción en DynamoDB?

- [ ] A. 1 segundo exacto
- [ ] B. 5 segundos exactos
- [ ] C. 10 segundos como referencia de estudio habitual
- [ ] D. No existe ningún límite temporal

### 9. Si una Lambda necesita conectarse a una base de datos privada en AWS, ¿qué concepto de red suele ser relevante?

- [ ] A. VPC
- [ ] B. Route 53 Hosted Zone
- [ ] C. AWS Budgets
- [ ] D. AWS Artifact

### 10. ¿Qué servicio almacena objetos de forma duradera y escalable?

- [ ] A. Amazon EFS
- [ ] B. Amazon S3
- [ ] C. Amazon MQ
- [ ] D. AWS Device Farm

### 11. ¿Qué beneficio principal aporta CloudWatch Logs en un backend serverless?

- [ ] A. Permitir consultas SQL sobre RDS
- [ ] B. Centralizar logs para diagnóstico
- [ ] C. Reemplazar IAM policies
- [ ] D. Gestionar secretos

### 12. ¿Para qué sirven las métricas personalizadas en CloudWatch?

- [ ] A. Para almacenar binarios de despliegue
- [ ] B. Para medir eventos técnicos o de negocio
- [ ] C. Para crear usuarios en Cognito
- [ ] D. Para abrir puertos en un Security Group

### 13. ¿Qué problema reduce el uso de parámetros SQL en una Lambda .NET que escribe en MySQL?

- [ ] A. SQL injection
- [ ] B. Cold starts
- [ ] C. Límite de memoria
- [ ] D. Expiración de tokens JWT

### 14. ¿Qué acción de IAM necesita una Lambda para leer un secreto en Secrets Manager?

- [ ] A. `cloudwatch:PutMetricData`
- [ ] B. `s3:GetObject`
- [ ] C. `secretsmanager:GetSecretValue`
- [ ] D. `ec2:DescribeRouteTables`

### 15. Si API Gateway devuelve 500, ¿cuál es una primera fuente recomendada para revisar el detalle técnico?

- [ ] A. CloudWatch Logs de Lambda
- [ ] B. Amazon S3 Inventory
- [ ] C. Security Hub
- [ ] D. AWS Shield

### 16. ¿Qué archivo describe recursos serverless como funciones, eventos y variables de entorno en este tipo de solución?

- [ ] A. `template.yaml`
- [ ] B. `Dockerfile`
- [ ] C. `build.gradle.kts`
- [ ] D. `Info.plist`

### 17. En SAM, ¿qué comando empaqueta y compila artefactos antes del despliegue?

- [ ] A. `sam build`
- [ ] B. `sam logs`
- [ ] C. `sam sync --watch`
- [ ] D. `sam init`

### 18. ¿Qué archivo suele guardar parámetros por defecto para despliegues SAM?

- [ ] A. `settings.json`
- [ ] B. `samconfig.toml`
- [ ] C. `.env.production`
- [ ] D. `pubspec.lock`

### 19. ¿Cuál es la mejor descripción del principio de mínimo privilegio?

- [ ] A. Dar permisos de administrador para simplificar soporte
- [ ] B. Otorgar solo los permisos estrictamente necesarios
- [ ] C. Reutilizar la misma policy para todos los servicios
- [ ] D. Evitar usar roles en producción

### 20. ¿Qué servicio usarías para autenticar usuarios de una app Flutter con login, registro y tokens?

- [ ] A. Cognito User Pools
- [ ] B. CloudWatch Logs
- [ ] C. AWS Backup
- [ ] D. Elastic Beanstalk

### 21. ¿Qué componente suele validar qué usuario puede invocar una API protegida?

- [ ] A. IAM o Cognito según el modelo de acceso
- [ ] B. Solo RDS
- [ ] C. Solo S3
- [ ] D. Solo CloudWatch

### 22. ¿Qué ventaja ofrece usar CloudWatch métricas además de logs?

- [ ] A. Permiten alarmas y seguimiento cuantitativo
- [ ] B. Reemplazan la base de datos
- [ ] C. Despliegan automáticamente SAM
- [ ] D. Deshabilitan cold starts

### 23. ¿Qué es lo más apropiado guardar en S3 en un sistema como este?

- [ ] A. Archivos, exportaciones o contenido estático
- [ ] B. Conexiones abiertas a MySQL
- [ ] C. Roles de IAM
- [ ] D. Reglas de Security Groups

### 24. ¿Qué ocurre si una app móvil tiene configurado el endpoint o la región incorrectos para la API?

- [ ] A. La llamada puede fallar o apuntar al entorno equivocado
- [ ] B. CloudWatch corrige automáticamente la región
- [ ] C. RDS redirige la petición
- [ ] D. SAM actualiza el cliente al arrancar

### 25. Si la Lambda no encuentra la variable `DB_SECRET_ID`, ¿qué tipo de problema es primero?

- [ ] A. Problema de configuración
- [ ] B. Problema de licencia
- [ ] C. Problema de compilador Flutter
- [ ] D. Problema de DNS del móvil

### 26. ¿Qué servicio ayuda a crear alarmas ante errores repetidos o métricas anómalas?

- [ ] A. CloudWatch Alarms
- [ ] B. AWS Glue
- [ ] C. AWS Snowball
- [ ] D. Amazon Macie

### 27. ¿Qué ventaja aporta incluir un `RequestId` en logs y respuestas?

- [ ] A. Facilita la correlación y el diagnóstico
- [ ] B. Aumenta la capacidad de almacenamiento de S3
- [ ] C. Evita configurar IAM
- [ ] D. Sustituye las métricas

### 28. ¿Cuál es un síntoma típico de un problema de Security Groups entre Lambda y RDS?

- [ ] A. Timeout o fallo de conexión a MySQL
- [ ] B. Error de compilación en Dart
- [ ] C. Conflicto de ramas en Git
- [ ] D. Favicon roto en Flutter web

### 29. ¿Qué rol tiene API Gateway en una solución serverless?

- [ ] A. Actuar como puerta de entrada HTTP para backend
- [ ] B. Ejecutar consultas SQL directamente
- [ ] C. Reemplazar Secrets Manager
- [ ] D. Sustituir a GitHub Actions

### 30. Si quieres proteger una API consumida por una app móvil con usuarios autenticados, ¿qué combinación es común?

- [ ] A. API Gateway + Cognito
- [ ] B. RDS + S3
- [ ] C. CloudWatch + Route 53
- [ ] D. VPC + ECR

### 31. ¿Cuál es un buen motivo para usar Secrets Manager en lugar de poner credenciales directamente en código o variables sin control?

- [ ] A. Mejora rotación, control y seguridad de secretos
- [ ] B. Reduce tamaño de la app móvil
- [ ] C. Elimina necesidad de API Gateway
- [ ] D. Evita usar IAM completamente

### 32. ¿Qué práctica de CI/CD es más recomendable antes de desplegar una Lambda con SAM?

- [ ] A. Ejecutar análisis y pruebas automáticas
- [ ] B. Desplegar siempre sin validar nada
- [ ] C. Borrar logs anteriores
- [ ] D. Quitar variables de entorno

### 33. En GitHub Actions, ¿para qué sirven los secrets del repositorio?

- [ ] A. Para almacenar valores sensibles como credenciales
- [ ] B. Para reemplazar todos los archivos YAML
- [ ] C. Para crear tablas en MySQL automáticamente
- [ ] D. Para almacenar artefactos grandes indefinidamente

### 34. ¿Qué problema intenta evitar el principio de no hardcodear credenciales en Flutter?

- [ ] A. Exposición de datos sensibles en cliente
- [ ] B. Uso de Material 3
- [ ] C. Dependencias de Provider
- [ ] D. Errores de maquetación

### 35. ¿Cuál es una diferencia importante entre logs y métricas?

- [ ] A. Los logs detallan eventos; las métricas resumen señales numéricas
- [ ] B. Los logs solo sirven en frontend
- [ ] C. Las métricas no pueden generar alarmas
- [ ] D. Son exactamente lo mismo

### 36. ¿Qué servicio de AWS define permisos para que GitHub Actions pueda desplegar recursos en una cuenta?

- [ ] A. IAM
- [ ] B. Cognito
- [ ] C. API Gateway
- [ ] D. S3 Glacier

### 37. ¿Qué escenario describe mejor un uso de S3 en este contexto como bonus de arquitectura?

- [ ] A. Guardar reportes exportados o assets estáticos
- [ ] B. Sustituir completamente MySQL
- [ ] C. Ejecutar código .NET
- [ ] D. Definir reglas de VPC

### 38. ¿Qué ventaja ofrece separar entornos como `dev`, `stg` y `prod`?

- [ ] A. Reducir riesgo y aislar cambios
- [ ] B. Eliminar necesidad de logs
- [ ] C. Evitar usar ramas en Git
- [ ] D. Impedir uso de API Gateway

### 39. ¿Qué fallo es más probable si el secreto existe pero el JSON no tiene `host` o `password`?

- [ ] A. Error de validación/configuración al crear conexión
- [ ] B. Error de iconos en Flutter
- [ ] C. Fallo en `flutter analyze` por tipos
- [ ] D. Error en `actions/checkout`

### 40. ¿Qué métrica de negocio sería razonable emitir en CloudWatch para este backend?

- [ ] A. Ajustes creados correctamente
- [ ] B. Número de archivos `.dart`
- [ ] C. Número de branches en GitHub
- [ ] D. Tamaño del README

### 41. ¿Qué servicio ayuda a observar si una Lambda está tardando demasiado?

- [ ] A. CloudWatch
- [ ] B. Cognito
- [ ] C. IAM Access Analyzer
- [ ] D. S3

### 42. ¿Qué ventaja tiene usar logs estructurados JSON con Serilog?

- [ ] A. Facilitan filtrado y búsqueda por campos
- [ ] B. Reducen a cero los costos de ejecución
- [ ] C. Sustituyen las policies IAM
- [ ] D. Eliminan todos los bugs de serialización

### 43. ¿Cuál es el propósito principal de una VPC?

- [ ] A. Proveer aislamiento y control de red
- [ ] B. Crear identidades de usuario final
- [ ] C. Almacenar objetos estáticos
- [ ] D. Ejecutar workflows CI

### 44. ¿Qué combinación describe mejor una ruta típica del tráfico en este proyecto?

- [ ] A. Flutter -> API Gateway -> Lambda -> RDS
- [ ] B. Flutter -> S3 -> IAM -> RDS
- [ ] C. Flutter -> Cognito -> CloudWatch -> Lambda
- [ ] D. Flutter -> Route 53 -> Secrets Manager -> S3

### 45. Si una Lambda necesita publicar métricas personalizadas, ¿qué permiso debe tener?

- [ ] A. `cloudwatch:PutMetricData`
- [ ] B. `rds:Connect`
- [ ] C. `s3:DeleteBucket`
- [ ] D. `cognito-idp:AdminDeleteUser`

### 46. ¿Qué beneficio tiene usar API Gateway delante de Lambda?

- [ ] A. Gestionar rutas, métodos y capa HTTP
- [ ] B. Sustituir completamente IAM
- [ ] C. Reemplazar la base de datos
- [ ] D. Evitar el uso de logs

### 47. ¿Cuál es una razón para no dejar una API crítica con autorización `NONE`?

- [ ] A. Quedaría expuesta sin control de acceso
- [ ] B. CloudWatch dejaría de funcionar
- [ ] C. SAM no soporta rutas públicas
- [ ] D. MySQL dejaría de aceptar conexiones

### 48. ¿Qué error conceptual es común al estudiar IAM y Cognito?

- [ ] A. Pensar que son exactamente el mismo servicio
- [ ] B. Creer que API Gateway tiene rutas
- [ ] C. Asumir que RDS usa SQL
- [ ] D. Decir que S3 guarda objetos

### 49. ¿Cuál es una buena pregunta de diagnóstico cuando falla la app móvil al consumir la API?

- [ ] A. ¿El endpoint, stage y región configurados son correctos?
- [ ] B. ¿Cuántos iconos tiene el proyecto?
- [ ] C. ¿Qué tamaño tiene el archivo `.sln`?
- [ ] D. ¿Qué fuente usa el tema visual?

### 50. ¿Qué indica mejor una estrategia sana de CI/CD?

- [ ] A. Build, análisis, pruebas y despliegue controlado
- [ ] B. Solo despliegue manual sin logs
- [ ] C. Commits directos a producción sin validación
- [ ] D. Quitar monitoreo para simplificar

### 51. ¿Qué servicio usarías para almacenar una imagen o exportación generada por la app o backend?

- [ ] A. Amazon S3
- [ ] B. IAM
- [ ] C. CloudWatch Logs
- [ ] D. API Gateway

### 52. ¿Qué componente es más apropiado para centralizar autenticación de usuarios móviles?

- [ ] A. Amazon Cognito
- [ ] B. Security Groups
- [ ] C. Amazon RDS
- [ ] D. SAM CLI

### 53. ¿Qué error operativo puede aparecer si una Lambda no tiene permisos para leer un secreto?

- [ ] A. Acceso denegado al pedir el valor del secreto
- [ ] B. Falla de compilación de Kotlin
- [ ] C. Pérdida del historial de Git
- [ ] D. Problema de layout en iOS

### 54. ¿Qué ventaja tiene definir infraestructura con SAM respecto a configurar recursos manualmente desde consola?

- [ ] A. Repetibilidad, versionado y automatización
- [ ] B. Menor necesidad de comprender arquitectura
- [ ] C. Eliminar el uso de políticas IAM
- [ ] D. No necesitar credenciales

### 55. ¿Qué controlan los Security Groups en una base de datos RDS?

- [ ] A. Qué tráfico puede entrar o salir
- [ ] B. Qué usuarios SQL existen
- [ ] C. Qué logs se envían a CloudWatch
- [ ] D. Qué ramas activan GitHub Actions

### 56. ¿Qué harías primero si una consulta a RDS empieza a fallar tras un despliegue?

- [ ] A. Revisar logs, cambios de configuración y conectividad
- [ ] B. Borrar el bucket S3
- [ ] C. Eliminar el stack SAM
- [ ] D. Quitar todos los Security Groups

### 57. ¿Qué aporta `sam deploy` después de `sam build`?

- [ ] A. Publica los recursos y cambios en AWS
- [ ] B. Ejecuta pruebas unitarias de Flutter
- [ ] C. Genera íconos para la app
- [ ] D. Reemplaza CloudWatch

### 58. ¿Qué dato suele ser útil al investigar un fallo end-to-end?

- [ ] A. Un identificador de request correlacionable
- [ ] B. El color del tema de la app
- [ ] C. El número total de archivos PNG
- [ ] D. El tamaño del repositorio en MB

### 59. ¿Qué escenario sugiere un problema de red más que uno de lógica?

- [ ] A. Timeout al abrir conexión a MySQL
- [ ] B. Validación de payload vacía
- [ ] C. JSON con campo faltante
- [ ] D. Error de formato en respuesta al usuario

### 60. ¿Qué patrón de estudio es mejor para este examen?

- [ ] A. Combinar teoría, preguntas y labs repetidos
- [ ] B. Memorizar respuestas sin contexto
- [ ] C. Estudiar solo frontend
- [ ] D. Omitir observabilidad

### 61. ¿Cuál es una mejora típica para una API detrás de API Gateway usada desde móvil?

- [ ] A. Añadir autenticación con Cognito
- [ ] B. Eliminar logs
- [ ] C. Quitar manejo de errores
- [ ] D. Guardar secretos en el cliente

### 62. ¿Qué valor aporta GitHub Actions en este repositorio como bonus?

- [ ] A. Automatizar análisis, build y despliegue
- [ ] B. Reemplazar RDS
- [ ] C. Crear VPCs automáticamente sin configuración
- [ ] D. Sustituir todas las pruebas manuales

### 63. ¿Qué servicio es más adecuado para emitir una alarma si suben los errores del backend?

- [ ] A. CloudWatch
- [ ] B. Cognito
- [ ] C. RDS Proxy
- [ ] D. Route 53 Resolver

### 64. ¿Cuál es un riesgo de usar credenciales AWS largas directamente en un workflow de CI/CD sin una estrategia más segura?

- [ ] A. Mayor superficie de exposición y rotación manual
- [ ] B. Menor tiempo de build
- [ ] C. Mejor separación de entornos
- [ ] D. Menor dependencia de IAM

### 65. ¿Qué describe mejor la diferencia entre Cognito e IAM?

- [ ] A. Cognito gestiona usuarios de app; IAM gestiona permisos AWS
- [ ] B. Cognito es para métricas; IAM para logs
- [ ] C. Cognito crea VPCs; IAM crea buckets
- [ ] D. Son equivalentes en todos los casos

### 66. ¿Qué componente ayuda a decidir si un puerto como 3306 está permitido entre Lambda y RDS?

- [ ] A. Security Groups
- [ ] B. CloudWatch Dashboards
- [ ] C. Cognito User Pools
- [ ] D. AWS SAM Metadata

### 67. ¿Qué ventaja tiene separar preguntas en bloques y dejar parte como tarea si solo hay 2 horas?

- [ ] A. Mantener foco sin sacrificar cobertura total
- [ ] B. Evitar estudiar los temas difíciles
- [ ] C. Eliminar la necesidad de labs
- [ ] D. Cambiar el stack técnico del examen

### 68. ¿Qué opción refleja mejor una buena práctica de respuesta a incidentes?

- [ ] A. Revisar impacto, logs, métricas y último cambio desplegado
- [ ] B. Cambiar varias cosas a la vez sin registrar nada
- [ ] C. Borrar evidencias para simplificar análisis
- [ ] D. Compartir secretos con el equipo por chat

### 69. ¿Qué relación tiene CloudWatch con GitHub Actions en el ejemplo visto?

- [ ] A. Puede recibir logs del pipeline para observabilidad
- [ ] B. Reemplaza a GitHub completamente
- [ ] C. Ejecuta los runners de Actions
- [ ] D. Almacena el código fuente del repositorio

### 70. ¿Qué enfoque general resume mejor la preparación deseada?

- [ ] A. Dominar AWS aplicado a casos reales de Flutter, .NET y serverless
- [ ] B. Estudiar solo teoría sin tocar despliegues
- [ ] C. Centrar todo el examen en diseño visual móvil
- [ ] D. Ignorar seguridad y observabilidad
