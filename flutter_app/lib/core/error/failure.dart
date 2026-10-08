sealed class Failure implements Exception {
  const Failure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure();
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

final class ServerFailure extends Failure {
  const ServerFailure({this.statusCode});

  final int? statusCode;
}

final class ParseFailure extends Failure {
  const ParseFailure();
}

final class CancelledFailure extends Failure {
  const CancelledFailure();
}

final class UnknownFailure extends Failure {
  const UnknownFailure(this.cause);

  final Object cause;
}
