import 'package:flutter_bloc/flutter_bloc.dart';

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
    try {
      final accounts = await _repository.getAccounts();
      emit(AccountSuccess(accounts));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onAccountsWatchRequested(
    AccountsWatchRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());
    await emit.forEach(
      _repository.watchAccounts(),
      onData: AccountSuccess.new,
      onError: (error, _) => AccountError(error.toString()),
    );
  }
}
