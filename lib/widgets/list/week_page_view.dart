import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iut_lr_app/stores/date_store.dart';
import 'package:provider/provider.dart';

import '../../apis/dateTime_apis.dart';
import '../week.dart';

class WeekPageView extends StatefulWidget {
  const WeekPageView({Key key}) : super(key: key);

  @override
  _WeekPageViewState createState() => _WeekPageViewState();
}

class _WeekPageViewState extends State<WeekPageView> {
  PageController _pageController;

  DateTime _getFirstMondayOfWeek({int week}) {
    DateTime date = DateTime(1900).add(Duration(days: (week - 1) * 7));
    return DateTime(date.year, date.month, date.day + (1 - date.weekday));
  }

  @override
  void initState() {
    final selectedDate = context.read<DateStore>().selectedDate.value;
    var diff = selectedDate
                .difference(_getFirstMondayOfWeek(week: DateTime(1900).week))
                .inDays /
            7 +
        0.1;
    _pageController = PageController(initialPage: diff.ceil());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dateStore = context.watch<DateStore>();
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        DateTime date = DateTime(1900).add(Duration(days: 7 * index));
        return Observer(builder: (context) {
          return Week(
            week: date.week,
            year: date.year,
            selectedDate: dateStore.selectedDate.value,
          );
        });
      },
    );
  }
}
