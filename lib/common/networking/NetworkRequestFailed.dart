class NetworkRequestFailed implements Exception {
  String message;
  String url;
  Object exception;
  StackTrace trace;

  NetworkRequestFailed.full(this.url, this.exception, this.trace);
  NetworkRequestFailed.message(this.message, this.url);

  @override
  String toString() {
    return "$message (url: $url , exception: $exception) stack: $trace";
  }
}

class EndpointUrlInvalid implements Exception {}
