import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCard extends StatelessWidget {
  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  const DateCard({
    Key key,
    @required this.date,
    this.selected = false,
    @required this.onTap,
  })  : assert(date != null),
        assert(selected != null),
        super(key: key);

  String _getFirstLetterOfWeekDay() {
    return DateFormat.E().format(date)[0].toUpperCase();
  }

  String _getDay() {
    return DateFormat.d().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              _getFirstLetterOfWeekDay(),
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: selected ? Colors.white : null,
                  ),
            ),
            Text(
              _getDay(),
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: selected ? Colors.white : null,
                    fontSize: 22.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
