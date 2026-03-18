# Anexo C: Preguntas tipo examen AWS

## P1. ¿Cuál es la política IAM mínima para que una Lambda escriba en DynamoDB?

Respuesta:
`dynamodb:PutItem` sobre la tabla específica, siguiendo el principio de least privilege.

## P2. ¿Qué es un trust relationship en IAM?

Respuesta:
Define qué principal o servicio puede asumir un rol.

## P3. ¿Cuál es el timeout máximo de API Gateway?

Respuesta:
29 segundos en escenarios clásicos de integración síncrona.

## P4. ¿Cuál es el timeout máximo de Lambda?

Respuesta:
15 minutos, configurable hasta ese límite.

## P5. ¿Qué es cold start en Lambda?

Respuesta:
Es la latencia adicional de una invocación inicial cuando el entorno de ejecución debe inicializarse.

## P6. ¿Cuánto dura una presigned URL por defecto?

Respuesta:
Depende del SDK o implementación utilizada; comúnmente se configura en 1 hora, es decir, 3600 segundos.

## P7. En DynamoDB, ¿qué es la partition key?

Respuesta:
Es la clave que determina cómo se distribuyen físicamente los datos y cómo se localizan los ítems.

## P8. ¿Cuál es el máximo tiempo de transacción en DynamoDB?

Respuesta:
La ventana transaccional práctica es corta; como referencia de estudio suele mencionarse 10 segundos para ciertos escenarios de control y reintento.

