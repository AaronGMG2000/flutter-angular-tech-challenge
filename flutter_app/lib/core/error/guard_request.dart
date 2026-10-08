import 'package:dio/dio.dart';
import 'package:catalog/core/error/dio_failure_mapper.dart';
import 'package:catalog/core/error/failure.dart';

Future<T> guardRequest<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on DioException catch (error, stackTrace) {
    Error.throwWithStackTrace(error.toFailure(), stackTrace);
  } on FormatException catch (_, stackTrace) {
    Error.throwWithStackTrace(const ParseFailure(), stackTrace);
  } on TypeError catch (_, stackTrace) {
    Error.throwWithStackTrace(const ParseFailure(), stackTrace);
  }
}
