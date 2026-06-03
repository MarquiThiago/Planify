import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repository/spending_statistics_repository_impl.dart';
import '../domain/repository/spending_statistics_repository.dart';
import '../presentation/bloc/spending_statistics_bloc.dart';

@module
abstract class SpendingStatisticsModule {
  @lazySingleton
  SpendingStatisticsRepository get spendingStatisticsRepository =>
      SpendingStatisticsRepositoryImpl(GetIt.instance<SupabaseClient>());

  SpendingStatisticsBloc get spendingStatisticsBloc =>
      SpendingStatisticsBloc(GetIt.instance<SpendingStatisticsRepository>());
}
