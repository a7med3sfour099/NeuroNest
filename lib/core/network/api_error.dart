class ApiError {
  final int? statusCode;
  final String message;

  ApiError({required this.message, this.statusCode});

  @override
  String toString() {
    return 'Error is(code: $statusCode, message: "$message")';
  }
}
