import 'package:currency_converter/app_colors.dart';
import 'package:currency_converter/app_styles.dart';
import 'package:currency_converter/components/currency_dialog.dart';
import 'package:currency_converter/components/faded_button.dart';
import 'package:currency_converter/components/key_pad.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final numberFormat = NumberFormat.decimalPattern('DA');
  List<Currency> _currencies = [];
  int _selected = 0;
  String _input = "";
  bool _keypad = true;

  bool get _notKeypad => !_keypad;

  double get _amount => _input.isEmpty ? 0 : double.parse(_input);

  double get _euro => _amount * _currencies[_selected].euro;

  @override
  void initState() {
    super.initState();
    fetchState();
  }

  fetchState() async {
    final List<Currency> currencies = await CurrencyState.fetch();
    setState(() => _currencies = currencies);
  }

  saveState() async {
    CurrencyState.update(_currencies);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: GestureDetector(
            onTap: onAddTap,
            child: Text("Currency Converter", style: AppStyles.textLargeWhite),
          ),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ReorderableListView(
                      children:
                          List.generate(_currencies.length, (int index) => _currencyBox(index)),
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          // These two lines are workarounds for ReorderableListView problems
                          if (newIndex > _currencies.length) newIndex = _currencies.length;
                          if (oldIndex < newIndex) newIndex--;

                          Currency item = _currencies[oldIndex];
                          _currencies.remove(item);
                          _currencies.insert(newIndex, item);
                        });
                        saveState();
                      },
                    ),
                  ),
                  Visibility(
                    visible: _notKeypad,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FadedButton(
                            text: 'Remove',
                            onTap: onRemoveTap,
                          ),
                        ),
                        Expanded(
                          child: FadedButton(
                            text: 'Add',
                            onTap: onAddTap,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _keypad,
                child: KeyPad(
                  onNumberPress: (int number) =>
                      setState(() => _input = _input + number.toString()),
                  onBackSpacePress: () =>
                      setState(() => _input = _input.substring(0, _input.length - 1)),
                  onLongBackSpacePress: () => setState(() => _input = ""),
                  onClosePress: () => setState(() => _keypad = false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currencyBox(int index) {
    Currency currency = _currencies[index];
    bool selected = _selected == index;
    double amount = selected ? _amount : (_euro / currency.euro);
    String value = numberFormat.format(amount.round());

    return GestureDetector(
      key: Key(index.toString()),
      onTap: () => _onCurrencyPress(index),
      child: Container(
        width: double.maxFinite,
        color: selected ? AppColors.blackActive : AppColors.blackInActive,
        padding: AppStyles.boxPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(currency.name, style: AppStyles.textLargeWhite),
            Text(value, style: AppStyles.textLargeWhite)
          ],
        ),
      ),
    );
  }

  void _onCurrencyPress(int index) => setState(() {
        _selected = index;
        _keypad = true;
      });

  void onRemoveTap() {
    if (_currencies.length <= 1) {
      return;
    }

    final deleteIndex = _selected;
    _selected = _selected == 0 ? 0 : _selected - 1;
    setState(() => _currencies.removeAt(deleteIndex));
    saveState();
  }

  void onAddTap() {
    showDialog(
      context: context,
      builder: (context) => CurrencyDialog(onConfirm: (currency) {
        setState(() => _currencies.add(currency));
        saveState();
      }),
    );
  }
}
