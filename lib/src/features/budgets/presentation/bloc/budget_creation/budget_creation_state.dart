import 'package:equatable/equatable.dart';

import '../../../../transactions/features/create_transaction/domain/entities/category_entity.dart';

sealed class BudgetCreationState extends Equatable {
  const BudgetCreationState();

  @override
  List<Object?> get props => [];
}

final class BudgetCreationStep1 extends BudgetCreationState {
  const BudgetCreationStep1();
}

final class BudgetCreationStep2 extends BudgetCreationState {
  const BudgetCreationStep2({
    required this.monthlyIncome,
    required this.savingsPct,
    required this.spendableAmount,
    required this.categories,
    required this.selectedCategoryIds,
  });

  final double monthlyIncome;
  final double savingsPct;
  final double spendableAmount;
  final List<CategoryEntity> categories;
  final List<String> selectedCategoryIds;

  bool get canProceed => selectedCategoryIds.isNotEmpty;

  BudgetCreationStep2 copyWith({List<String>? selectedCategoryIds}) {
    return BudgetCreationStep2(
      monthlyIncome: monthlyIncome,
      savingsPct: savingsPct,
      spendableAmount: spendableAmount,
      categories: categories,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
    );
  }

  @override
  List<Object?> get props => [
        monthlyIncome,
        savingsPct,
        spendableAmount,
        categories,
        selectedCategoryIds,
      ];
}

final class BudgetCreationStep3 extends BudgetCreationState {
  const BudgetCreationStep3({
    required this.spendableAmount,
    required this.selectedCategories,
    required this.allocations,
  });

  final double spendableAmount;
  final List<CategoryEntity> selectedCategories;
  final Map<String, double> allocations;

  double get totalAllocated => allocations.values.fold(0, (sum, v) => sum + v);
  double get remainingAmount => spendableAmount - totalAllocated;
  bool get canSubmit => remainingAmount >= 0 && allocations.values.every((v) => v > 0);

  BudgetCreationStep3 copyWith({Map<String, double>? allocations}) {
    return BudgetCreationStep3(
      spendableAmount: spendableAmount,
      selectedCategories: selectedCategories,
      allocations: allocations ?? this.allocations,
    );
  }

  @override
  List<Object?> get props => [spendableAmount, selectedCategories, allocations];
}

final class BudgetCreationLoading extends BudgetCreationState {
  const BudgetCreationLoading();
}

final class BudgetCreationSuccess extends BudgetCreationState {
  const BudgetCreationSuccess();
}

final class BudgetCreationError extends BudgetCreationState {
  const BudgetCreationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
