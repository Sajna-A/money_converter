part of 'currency_cubit.dart';

@immutable
abstract class CurrencyState {}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final double result;
  CurrencyLoaded({required this.result});
}

class CurrencyError extends CurrencyState {
  final String message;
  CurrencyError(this.message);
}
