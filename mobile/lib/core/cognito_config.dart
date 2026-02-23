class CognitoConfig {
  const CognitoConfig._();

  static const region = 'us-east-2';
  static const userPoolId = 'us-east-2_1cNEVfoNm';

  // TODO: Replace with your Cognito app client ID.
  static const appClientId = 'appClientId';

  // TODO: Replace with your Cognito Hosted UI domain.
  // Example: myapp.auth.us-east-2.amazoncognito.com
  static const hostedUiDomain = 'hostedUiDomain';

  // Must match callback URLs configured in Cognito app client settings.
  static const redirectScheme = 'dataqubeauth';
  static const redirectHost = 'callback';
  static const redirectUri = '$redirectScheme://$redirectHost';
}
