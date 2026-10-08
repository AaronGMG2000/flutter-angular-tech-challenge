import 'dart:io';

import 'package:catalog/core/error/failure.dart';
import 'package:dio/dio.dart';

extension DioFailureMapper on DioException {
  Failure toFailure() {
    return switch (type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => const TimeoutFailure(),
      DioExceptionType.connectionError ||
      DioExceptionType.badCertificate => const NetworkFailure(),
      DioExceptionType.badResponse => _fromStatusCode(response?.statusCode),
      DioExceptionType.cancel => const CancelledFailure(),
      DioExceptionType.unknown =>
        error is SocketException
            ? const NetworkFailure()
            : UnknownFailure(this),
    };
  }

  Failure _fromStatusCode(int? statusCode) {
    return switch (statusCode) {
      HttpStatus.notFound => const NotFoundFailure(),
      _ => ServerFailure(statusCode: statusCode),
    };
  }
}
