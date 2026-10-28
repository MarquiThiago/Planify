import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/failures/failures.dart';

import '../../domain/repository/account_repository.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc(this._repository) : super(const AccountInitial()) {
    on<AccountsLoadRequested>(_onAccountsLoadRequested);
    on<AccountsWatchRequested>(_onAccountsWatchRequested);
  }

  final AccountRepository _repository;

  Future<void> _onAccountsLoadRequested(
    AccountsLoadRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());
    final result = await _repository.getAccounts();
    result.fold(
      (failure) => emit(AccountError(failure)),
      (accounts) => emit(AccountSuccess(accounts)),
    );
  }

  Future<void> _onAccountsWatchRequested(
    AccountsWatchRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());
    await emit.forEach(
      _repository.watchAccounts(),
      onData: (result) => result.fold(
        (failure) => AccountError(failure),
        (accounts) => AccountSuccess(accounts),
      ),
      onError: (error, _) =>
          AccountError(UnexpectedFailure(error.toString(), null)),
    );
  }
}
