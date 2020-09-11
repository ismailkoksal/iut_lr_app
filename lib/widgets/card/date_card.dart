import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class DateCard extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final Function onTap;

  const DateCard({
    Key key,
    @required this.date,
    this.isSelected = false,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat.E().format(date)[0].toUpperCase(),
              style: kSubtitleStyle.copyWith(
                color: isSelected ? Colors.white : null,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              DateFormat.d().format(date),
              style: kTitle1Style.copyWith(
                color: isSelected ? Colors.white : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
