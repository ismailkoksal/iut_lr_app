import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iut_lr_app/bloc/get_selected_date_bloc.dart';

import 'card/date_card.dart';

class Week extends StatefulWidget {
  final int week;
  final int year;
  final DateTime selectedDate;

  const Week({
    Key key,
    @required this.week,
    @required this.year,
    @required this.selectedDate,
  }) : super(key: key);

  @override
  _WeekState createState() => _WeekState();
}

class _WeekState extends State<Week> {
  GlobalKey _key = GlobalKey();
  double _width;
  List<DateTime> _dateList;
  DateTime _monday;
  bool _isVisible = false;

  double _getWidth() {
    final RenderBox rb = _key.currentContext.findRenderObject();
    return rb.size.width;
  }

  DateTime _getFirstMondayOfWeek() {
    DateTime date =
        DateTime(widget.year).add(Duration(days: (widget.week - 1) * 7));
    return DateTime(date.year, date.month, date.day + (1 - date.weekday));
  }

  List<DateTime> _getDatesOfWeek() {
    return List.generate(7, (index) => _monday.add(Duration(days: index)));
  }

  bool _isSelected(DateTime date) =>
      DateFormat.yMd().format(date) ==
      DateFormat.yMd().format(widget.selectedDate);

  int get _getSelectedDateIndex =>
      _dateList.indexWhere((date) => _isSelected(date));

  bool get _isIndicatorVisible {
    DateTime sunday =
        _monday.add(Duration(days: 7)).subtract(Duration(seconds: 1));
    return widget.selectedDate.isAtSameMomentAs(_monday) ||
        widget.selectedDate.isAfter(_monday) &&
            widget.selectedDate.isBefore(sunday) &&
            _width != null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          _width = _getWidth();
          _isVisible = _isIndicatorVisible;
        }));
    _monday = _getFirstMondayOfWeek();
    _dateList = _getDatesOfWeek();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _key,
      children: [
        if (_isVisible) _buildIndicator,
        _buildWeekRow,
      ],
    );
  }

  Widget get _buildIndicator => AnimatedPositioned(
        top: 0,
        bottom: 0,
        left: _width / 7 * _getSelectedDateIndex,
        width: _width / 7,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Theme.of(context).indicatorColor,
          ),
        ),
      );

  Widget get _buildWeekRow => Row(
        children: _dateList.map((date) {
          return Expanded(
            child: DateCard(
              date: date,
              selected: _isSelected(date),
              onTap: () {
                if (!widget.selectedDate.isAtSameMomentAs(date)) {
                  _isVisible = true;
                  selectedDateBloc.setSelectedDate(date);
                }
              },
            ),
          );
        }).toList(),
      );
}
