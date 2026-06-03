import '../entities/spending_statistics_entity.dart';

abstract class SpendingStatisticsRepository {
  Stream<SpendingStatisticsEntity> watchSpendingStatistics({
    required int year,
    required int month,
    required String type,
  });
}
