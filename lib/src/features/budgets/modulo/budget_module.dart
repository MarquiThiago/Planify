import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../transactions/features/create_transaction/domain/repository/category_repository.dart';
import '../data/repository/budget_repository_impl.dart';
import '../domain/repository/budget_repository.dart';
import '../presentation/bloc/budget_creation/budget_creation_bloc.dart';
import '../presentation/bloc/budget_overview/budget_overview_bloc.dart';

@module
abstract class BudgetModule {
  @lazySingleton
  BudgetRepository get budgetRepository =>
      BudgetRepositoryImpl(GetIt.instance());

  BudgetOverviewBloc get budgetOverviewBloc =>
      BudgetOverviewBloc(GetIt.instance<BudgetRepository>());

  BudgetCreationBloc get budgetCreationBloc => BudgetCreationBloc(
        GetIt.instance<BudgetRepository>(),
        GetIt.instance<CategoryRepository>(),
      );
}
