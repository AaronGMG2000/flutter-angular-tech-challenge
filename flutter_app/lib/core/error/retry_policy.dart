import 'dart:io';

import 'package:catalog/core/error/failure.dart';

const int _maxRetries = 2;
const Duration _baseDelay = Duration(milliseconds: 500);

Duration? retryPolicy(int retryCount, Object error) {
  if (retryCount >= _maxRetries) return null;
  return switch (error) {
    NetworkFailure() || TimeoutFailure() => _backoff(retryCount),
    ServerFailure(statusCode: final code?)
        when code >= HttpStatus.internalServerError =>
      _backoff(retryCount),
    _ => null,
  };
}

Duration _backoff(int retryCount) => _baseDelay * (retryCount + 1);
