import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit() : super(CurrencyInitial());

  // Method to fetch exchange rates and convert
  Future<void> convertCurrency(
      double amount, String fromCurrency, String toCurrency) async {
    emit(CurrencyLoading());
    try {
      final response = await http.get(Uri.parse(
          'https://api.exchangerate-api.com/v4/latest/$fromCurrency'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        double rate = data['rates'][toCurrency];
        double result = amount * rate;
        emit(CurrencyLoaded(result: result));
      } else {
        emit(CurrencyError('Failed to load exchange rate'));
      }
    } catch (e) {
      emit(CurrencyError('Failed to convert currency'));
    }
  }
}
