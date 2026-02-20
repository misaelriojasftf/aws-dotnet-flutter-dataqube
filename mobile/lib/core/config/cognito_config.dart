class CognitoConfig {
  const CognitoConfig._();

  static const region = 'us-east-2';
  static const userPoolId = 'us-east-2_FpSpwOn4X';

  // TODO: Replace with your Cognito app client ID.
  static const appClientId = 'YOUR_APP_CLIENT_ID';

  // TODO: Replace with your Cognito Hosted UI domain.
  // Example: myapp.auth.us-east-2.amazoncognito.com
  static const hostedUiDomain = 'YOUR_DOMAIN.auth.us-east-2.amazoncognito.com';

  // Must match callback URLs configured in Cognito app client settings.
  static const redirectScheme = 'dataqubeauth';
  static const redirectHost = 'callback';
  static const redirectUri = '$redirectScheme://$redirectHost';
}
