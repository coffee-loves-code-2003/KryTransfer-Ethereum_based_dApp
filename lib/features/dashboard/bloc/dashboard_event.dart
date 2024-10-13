part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class DashboardInitialFetchEvent extends DashboardEvent {}

class DashBoardGetAddress extends DashboardEvent {
  final TransactionModel transactionModel;
  DashBoardGetAddress({required this.transactionModel});
}

class DashBoardDepositEvent extends DashboardEvent {
  final TransactionModel transactionModel;

  DashBoardDepositEvent({required this.transactionModel});
}

class DashBoardWithdrawEvent extends DashboardEvent {
  final TransactionModel transactionModel;

  DashBoardWithdrawEvent({required this.transactionModel});
}

class TransferFundstoUser extends DashboardEvent {
  final TransactionModel transactionModel;
  TransferFundstoUser({required this.transactionModel});
}
