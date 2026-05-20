import 'package:equatable/equatable.dart';

import '../../domain/entities/account_entity.dart';

sealed class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

final class AccountInitial extends AccountState {
  const AccountInitial();
}

final class AccountLoading extends AccountState {
  const AccountLoading();
}

final class AccountSuccess extends AccountState {
  const AccountSuccess(this.accounts);

  final List<AccountEntity> accounts;

  @override
  List<Object?> get props => [accounts];
}

final class AccountError extends AccountState {
  const AccountError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
