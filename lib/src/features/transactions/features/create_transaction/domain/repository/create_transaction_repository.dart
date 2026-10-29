import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';

abstract class CreateTransactionRepository {
  Future<Either<Failure, Unit>> createTransaction({
    required String type,
    required double amount,
    required String accountId,
    required String categoryId,
    required DateTime date,
    String? description,
  });
}
