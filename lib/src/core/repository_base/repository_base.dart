import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../failures/failures.dart';

mixin RepositoryBase {
  Future<Either<Failure, T>> safeCall<T>(
    Future<T> Function() operation, {
    required String operationName,
    Map<String, dynamic> context = const {},
  }) async {
    try {
      final result = await operation();
      return Right(result);
    } on AuthException catch (e, st) {
      final failure = _isSessionError(e)
          ? SessionExpiredFailure(e.message, e.statusCode?.toString())
          : AuthFailure(e.message, e.statusCode?.toString());
      return _handleFailure(failure, st, operationName, context);
    } on PostgrestException catch (e, st) {
      return _handleFailure(
        DatabaseFailure(e.message, e.code, pgCode: e.code),
        st,
        operationName,
        context,
      );
    } on SocketException catch (e, st) {
      return _handleFailure(
        NetworkFailure(e.message, null),
        st,
        operationName,
        context,
      );
    } catch (e, st) {
      return _handleFailure(
        UnexpectedFailure('Unexpected error during $operationName', null),
        st,
        operationName,
        context,
      );
    }
  }

  Stream<Either<Failure, T>> safeWatch<T>(
    Stream<T> Function() operation, {
    required String operationName,
    Map<String, dynamic> context = const {},
  }) async* {
    try {
      await for (final result in operation()) {
        yield Right(result);
      }
    } on AuthException catch (e, st) {
      final failure = _isSessionError(e)
          ? SessionExpiredFailure(e.message, e.statusCode?.toString())
          : AuthFailure(e.message, e.statusCode?.toString());
      yield _handleFailure(failure, st, operationName, context);
    } on PostgrestException catch (e, st) {
      yield _handleFailure(
        DatabaseFailure(e.message, e.code, pgCode: e.code),
        st,
        operationName,
        context,
      );
    } on SocketException catch (e, st) {
      yield _handleFailure(
        NetworkFailure(e.message, null),
        st,
        operationName,
        context,
      );
    } catch (e, st) {
      yield _handleFailure(
        UnexpectedFailure('Unexpected error during $operationName', null),
        st,
        operationName,
        context,
      );
    }
  }

  bool _isSessionError(AuthException e) {
    const sessionCodes = ['401', '403'];
    return sessionCodes.contains(e.statusCode?.toString());
  }

  Either<Failure, T> _handleFailure<T>(
    Failure failure,
    StackTrace? stackTrace,
    String operationName,
    Map<String, dynamic> context,
  ) {
    return Left(failure);
  }
}
