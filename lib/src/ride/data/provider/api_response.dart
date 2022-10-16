class APIResponse {
  APIResponse(this.httpCode, this.responseBody);

  final int httpCode;
  dynamic responseBody;
}
