import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'currency_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => CurrencyCubit(),
        child: const CurrencyConverterScreen(),
      ),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Currency Converter',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _fromCurrency,
              onChanged: (value) {
                setState(() {
                  _fromCurrency = value!;
                });
              },
              items: ['USD', 'EUR', 'GBP', 'INR'].map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _toCurrency,
              onChanged: (value) {
                setState(() {
                  _toCurrency = value!;
                });
              },
              items: ['USD', 'EUR', 'GBP', 'INR'].map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text);
                if (amount != null) {
                  context
                      .read<CurrencyCubit>()
                      .convertCurrency(amount, _fromCurrency, _toCurrency);
                }
              },
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),
            BlocBuilder<CurrencyCubit, CurrencyState>(
              builder: (context, state) {
                if (state is CurrencyLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CurrencyLoaded) {
                  return Text(
                    'Result: ${state.result.toStringAsFixed(2)} $_toCurrency',
                    style: const TextStyle(fontSize: 24),
                  );
                } else if (state is CurrencyError) {
                  return Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const Text('Enter amount and convert');
              },
            ),
          ],
        ),
      ),
    );
  }
}
