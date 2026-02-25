// Reemplaza estos valores con tu AWS Cognito Hosted UI + S3.
window.COGNITO_CONFIG = {
  // Ejemplo: https://tu-dominio.auth.us-east-1.amazoncognito.com
  domain: "domain",
  clientId: "clientId",

  // Region de Cognito y S3
  region: "region",

  // User Pool usado para el Hosted UI (sin region en el valor)
  userPoolId: "userPoolId",

  // Identity Pool para entregar credenciales AWS temporales
  identityPoolId: "us-east-1:XXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",

  // Bucket donde guardar fotos
  s3Bucket: "s3Bucket",
  s3Prefix: "folder/",

  // Deben estar permitidas en App client -> Allowed callback/logout URLs
  redirectSignIn: "http://localhost:8080",
  redirectSignOut: "http://localhost:8080",

  // Flujo implicito para ejemplo rapido en web
  responseType: "token",
  scopes: ["openid", "email", "phone"],
};
