import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catalog/core/error/dio_failure_mapper.dart';
import 'package:catalog/core/error/failure.dart';

void main() {
  final requestOptions = RequestOptions(path: '/products/1');

  DioException badResponse(int statusCode) => DioException.badResponse(
    statusCode: statusCode,
    requestOptions: requestOptions,
    response: Response(requestOptions: requestOptions, statusCode: statusCode),
  );

  group('DioFailureMapper.toFailure', () {
    test('maps 404 to NotFoundFailure', () {
      expect(badResponse(404).toFailure(), isA<NotFoundFailure>());
    });

    test('maps 500 to ServerFailure keeping status code', () {
      expect(
        badResponse(500).toFailure(),
        isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 500),
      );
    });

    test('maps receive timeout to TimeoutFailure', () {
      final exception = DioException.receiveTimeout(
        timeout: const Duration(seconds: 10),
        requestOptions: requestOptions,
      );
      expect(exception.toFailure(), isA<TimeoutFailure>());
    });

    test('maps connection error to NetworkFailure', () {
      final exception = DioException.connectionError(
        requestOptions: requestOptions,
        reason: 'offline',
      );
      expect(exception.toFailure(), isA<NetworkFailure>());
    });
  });
}
