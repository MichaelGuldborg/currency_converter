import 'package:flutter/material.dart';

class KeyPad extends StatelessWidget {
  final Function(int) onNumberPress;
  final VoidCallback onBackSpacePress;
  final VoidCallback onClosePress;
  final VoidCallback onLongBackSpacePress;

  final Color color = Colors.white;

  const KeyPad({
    Key key,
    this.onNumberPress,
    this.onBackSpacePress,
    this.onLongBackSpacePress,
    this.onClosePress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: GridView.count(
        shrinkWrap: true,
        primary: false,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 2,
        crossAxisCount: 3,
        children: <Widget>[
          _numberButton(1),
          _numberButton(2),
          _numberButton(3),
          _numberButton(4),
          _numberButton(5),
          _numberButton(6),
          _numberButton(7),
          _numberButton(8),
          _numberButton(9),
          KeyPadButton(
            child: Icon(Icons.clear, color: Colors.white),
            onTap: onClosePress,
          ),
          _numberButton(0),
          KeyPadButton(
            child: Icon(Icons.backspace, color: Colors.white),
            onTap: onBackSpacePress,
            onLongPress: onLongBackSpacePress,
          ),
        ],
      ),
    );
  }

  Widget _numberButton(int number) => KeyPadButton(
        onTap: () => onNumberPress(number),
        child: Text(
          number.toString(),
          style: TextStyle(
            color: color,
            fontSize: 24,
          ),
        ),
      );
}

class KeyPadButton extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  const KeyPadButton({
    Key key,
    this.child,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(200),
      shape: Border.all(
        color: Colors.white,
        width: 0.1,
      ),
      child: InkWell(
        splashColor: Colors.white,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
