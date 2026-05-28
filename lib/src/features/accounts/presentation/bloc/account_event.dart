import 'package:equatable/equatable.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

final class AccountsLoadRequested extends AccountEvent {
  const AccountsLoadRequested();
}

final class AccountsWatchRequested extends AccountEvent {
  const AccountsWatchRequested();
}
