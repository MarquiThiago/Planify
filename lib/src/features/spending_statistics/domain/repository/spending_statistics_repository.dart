import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';

import '../entities/spending_statistics_entity.dart';

abstract class SpendingStatisticsRepository {
  Stream<Either<Failure, SpendingStatisticsEntity>> watchSpendingStatistics({
    required int year,
    required int month,
    required String type,
  });
}
