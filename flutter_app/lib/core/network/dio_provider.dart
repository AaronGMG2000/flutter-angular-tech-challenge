import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:catalog/core/constants/api_constants.dart';

part 'dio_provider.g.dart';

const Duration _connectTimeout = Duration(seconds: 10);
const Duration _receiveTimeout = Duration(seconds: 10);

@riverpod
Dio dio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
    ),
  );
}
