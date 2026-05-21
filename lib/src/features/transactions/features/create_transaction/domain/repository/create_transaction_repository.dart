abstract class CreateTransactionRepository {
  Future<void> createTransaction({
    required String type,
    required double amount,
    required String accountId,
    required String categoryId,
    required DateTime date,
    String? description,
  });
}
