import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iut_lr_app/constants.dart';

import '../apis/dateTime_apis.dart';
import 'card/date_card.dart';

class Week extends StatefulWidget {
  final int week;
  final DateTime selectedDate;
  final Function onDateTap;

  const Week({
    Key key,
    @required this.week,
    @required this.selectedDate,
    @required this.onDateTap,
  }) : super(key: key);

  @override
  _WeekState createState() => _WeekState();
}

class _WeekState extends State<Week> {
  GlobalKey _key = GlobalKey();
  double _width;
  List<DateTime> _dateList;

  double _getWidth() {
    final RenderBox rb = _key.currentContext.findRenderObject();
    return rb.size.width;
  }

  int _getSchoolStartYear() {
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    return month >= DateTime.september && month <= DateTime.december
        ? year
        : year - 1;
  }

  DateTime _getFirstMondayOfWeek({int week}) {
    DateTime date =
        DateTime(_getSchoolStartYear()).add(Duration(days: (week - 1) * 7));
    return DateTime(date.year, date.month, date.day + (1 - date.weekday));
  }

  List<DateTime> _getDatesOfWeek() {
    final firstMondayOfWeek = _getFirstMondayOfWeek(week: widget.week);
    return List.generate(
        7, (index) => firstMondayOfWeek.add(Duration(days: index)));
  }

  bool _isSelected(DateTime date) {
    return DateFormat.yMd().format(date) ==
        DateFormat.yMd().format(widget.selectedDate);
  }

  int _getSelectedDateIndex() {
    return _dateList.indexWhere((date) => _isSelected(date));
  }

  bool _isIndicatorVisible() {
    return widget.week == widget.selectedDate.week && _width != null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => _width = _getWidth()));
    _dateList = _getDatesOfWeek();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _key,
      children: [
        if (_isIndicatorVisible()) _buildIndicator,
        _buildWeekRow,
      ],
    );
  }

  Widget get _buildIndicator => AnimatedPositioned(
        duration: Duration(milliseconds: 500),
        height: 70,
        width: _width / 7,
        curve: Curves.easeOutCubic,
        left: _width / 7 * _getSelectedDateIndex(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: kOrangeColor,
          ),
        ),
      );

  Widget get _buildWeekRow => Row(
        children: _dateList.map((date) {
          return Expanded(
            child: DateCard(
              date: date,
              isSelected: _isSelected(date),
              onTap: () {
                widget.onDateTap(date);
              },
            ),
          );
        }).toList(),
      );
}
