// Reemplaza estos valores con tu AWS Cognito Hosted UI.
window.COGNITO_CONFIG = {
  // Ejemplo: https://tu-dominio.auth.us-east-1.amazoncognito.com
  domain: "https://TU-DOMINIO.auth.us-east-1.amazoncognito.com",
  clientId: "TU_APP_CLIENT_ID",

  // Deben estar permitidas en App client -> Allowed callback/logout URLs
  redirectSignIn: "http://localhost:8080",
  redirectSignOut: "http://localhost:8080",

  // "token" para flujo implicito simple
  responseType: "token",
  scopes: ["openid", "email", "profile"],
};
