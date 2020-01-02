import 'package:currency_converter/app_colors.dart';
import 'package:currency_converter/app_styles.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:flutter/material.dart';

typedef CurrencyCallback = void Function(Currency currency);

class CurrencyDialog extends StatelessWidget {
  final Function(Currency currency) onConfirm;

  const CurrencyDialog({Key key, this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _name = TextEditingController();
    final _euro = TextEditingController();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: AppStyles.bottomMargin,
              child: Text('Add currency', style: AppStyles.textTitle),
            ),
            Container(
              margin: AppStyles.bottomMargin,
              child: TextField(
                controller: _name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                  hintText: 'Name',
                  isDense: true,
                ),
              ),
            ),
            Container(
              margin: AppStyles.bottomMarginLarge,
              child: TextField(
                controller: _euro,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                  hintText: 'Euro value',
                  isDense: true,
                ),
              ),
            ),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              color: AppColors.button,
              child: Text('Confirm', style: AppStyles.textMediumWhite),
              onPressed: () {
                final String name = _name.text.trim();
                final double euro = double.parse(_euro.text.trim());
                final currency = Currency(name: name, euro: euro);
                onConfirm(currency);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
