class AwsConstants {
  static const amplifyConfig = '''
{
  "api": {
    "plugins": {
      "awsAPIPlugin": {
        "dataqubeApi": {
          "endpointType": "REST",
          "endpoint": "https://at5tdtdik0.execute-api.us-east-2.amazonaws.com",
          "region": "us-east-2",
          "authorizationType": "NONE"
        }
      }
    }
  }
}
''';

  static const lambdaApiName = 'dataqubeApi';
  static const lambdaPath = '/hello';
  static const adjustmentsPath = '/adjustments';

  static String adjustmentsByStorePath(String storeId) =>
      '/stores/$storeId/adjustments';
}
