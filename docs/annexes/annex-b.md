# Anexo B: Matriz de decisión

## DynamoDB vs RDS

| Aspecto | DynamoDB | RDS |
| --- | --- | --- |
| Latencia | Ultra-baja, típicamente menor a 5 ms | Baja, típicamente entre 10 y 50 ms |
| Escalado | Automático | Más guiado por configuración |
| Transacciones | Limitadas frente a un motor relacional | ACID completo |
| Joins | No | Sí |
| Reportes | Más difícil | Más fácil |
| Costo para MVP | Puede subir rápido según acceso | A menudo más predecible al inicio |

Decisión:
DynamoDB para datos calientes y acceso clave-valor de alta escala; RDS para reportes, consultas relacionales y necesidades SQL más completas.

## Lambda vs EC2

| Aspecto | Lambda | EC2 |
| --- | --- | --- |
| Mantenimiento | Muy bajo | Tu responsabilidad |
| Costo | Pago por uso | Instancia fija o reservada |
| Timeout | Máximo 15 minutos | No orientado al mismo límite de ejecución |
| Escalado | Automático | Requiere gestión adicional |

Decisión:
Lambda para APIs, automatizaciones y procesamiento por eventos; EC2 para procesos largos, cargas persistentes o software que requiere más control del servidor.
