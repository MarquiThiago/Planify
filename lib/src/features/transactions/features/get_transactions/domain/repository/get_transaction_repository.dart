import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';

import '../entities/transaction_entity.dart';

abstract class GetTransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(
    int year,
    int month,
  );
}
