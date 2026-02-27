/// Replace these values with your Amplify backend output.
class AwsConstants {
  static const amplifyConfig = '''
{
  "api": {
    "plugins": {
      "awsAPIPlugin": {
        "dataqubeApi": {
          "endpointType": "REST",
          "endpoint": "https://YOUR_API_ID.execute-api.YOUR_REGION.amazonaws.com/prod",
          "region": "YOUR_REGION",
          "authorizationType": "NONE"
        }
      }
    }
  }
}
''';

  static const lambdaApiName = 'dataqubeApi';
  static const lambdaPath = '/hello';
}
