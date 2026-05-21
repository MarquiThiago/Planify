import '../entities/transaction_entity.dart';

abstract class GetTransactionRepository {
  Future<List<TransactionEntity>> getTransactions(int year, int month);
}
