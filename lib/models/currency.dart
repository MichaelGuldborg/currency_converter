import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Currency {
  final String name;
  final double euro;

  const Currency({
    this.name = "XXX",
    this.euro = 1.0,
  });

  factory Currency.fromMap(Map<String, Object> map) {
    return Currency(
      name: map['name'],
      euro: map['euro'],
    );
  }

  Map<String, Object> toMap() {
    return {
      'name': name,
      'euro': euro,
    };
  }
}

class CurrencyState {
  static const PREF_KEY = "CURRENCIES";
  static const DEFAULT = const [
    Currency(name: 'DKK', euro: 0.134108),
    Currency(name: 'KWR', euro: 0.000751540),
    Currency(name: 'EUR', euro: 1.0),
  ];

  static Future<List<Currency>> fetch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String currencyJson = prefs.getString(PREF_KEY);
    if (currencyJson == null || currencyJson.isEmpty) {
      return update(DEFAULT);
    }

    final currencyList = jsonDecode(currencyJson) as List;
    return currencyList.map((currency) => Currency.fromMap(currency)).toList();
  }

  static Future<List<Currency>> update(List<Currency> currencyList) async {
    if (currencyList == null || currencyList.isEmpty) {
      return currencyList;
    }
    final currencyMapList = currencyList.map((currency) => currency.toMap()).toList();
    final String currencyJson = jsonEncode(currencyMapList);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PREF_KEY, currencyJson);
    return currencyList;
  }
}
