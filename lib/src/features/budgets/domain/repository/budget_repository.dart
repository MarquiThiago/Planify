import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';

import '../entities/budget_group_entity.dart';

abstract class BudgetRepository {
  Future<Either<Failure, Unit>> createBudgetGroup({
    required double monthlyIncome,
    required double savingsPct,
    required DateTime period,
    required Map<String, double> categoryAllocations,
  });

  Future<Either<Failure, BudgetGroupEntity?>> getBudgetGroup(DateTime period);

  Stream<Either<Failure, BudgetGroupEntity?>> watchBudgetGroup(DateTime period);

  Future<Either<Failure, Unit>> deleteBudgetGroup(String groupId);
}
