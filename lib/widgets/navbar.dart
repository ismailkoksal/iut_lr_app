import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iut_lr_app/bloc/get_selected_date_bloc.dart';
import 'package:iut_lr_app/themes/theme.dart';
import 'package:iut_lr_app/user.dart';
import 'package:iut_lr_app/widgets/week.dart';

import '../apis/dateTime_apis.dart';
import '../apis/string_apis.dart';
import '../settings_store.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    Key key,
  }) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  PageController _pageController;
  Future<String> _studentName;

  DateTime _getFirstMondayOfWeek({int week}) {
    DateTime date =
        DateTime(_getSchoolStartYear()).add(Duration(days: (week - 1) * 7));
    return DateTime(date.year, date.month, date.day + (1 - date.weekday));
  }

  int _getSchoolStartYear() {
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    return month >= DateTime.september && month <= DateTime.december
        ? year
        : year - 1;
  }

  bool isSelected(DateTime date) {
    return DateFormat.yMd().format(date) ==
        DateFormat.yMd().format(selectedDateBloc.subject.value);
  }

  @override
  void initState() {
    super.initState();
    var diff = selectedDateBloc.subject.value
            .difference(_getFirstMondayOfWeek(
                week: DateTime(_getSchoolStartYear(), DateTime.september).week))
            .inDays /
        7;
    _pageController = PageController(initialPage: diff.floor());
    _studentName = User.studentName;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0)),
      child: Container(
        color: Theme.of(context).appBarTheme.color,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.wb_sunny),
                  onPressed: () => SettingsStore.of(context).updateTheme(
                      SettingsStore.of(context).theme.value ==
                              appThemeData[AppTheme.Dark]
                          ? AppTheme.Light
                          : AppTheme.Dark),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 30.0),
                      child: FutureBuilder(
                        future: _studentName,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          return snapshot.hasData
                              ? Text(
                                  'Salut, ${snapshot.data.toTitleCase()}!',
                                  style: Theme.of(context).textTheme.headline6,
                                )
                              : SizedBox.shrink();
                        },
                      ),
                    ),
                    // const SizedBox(height: 10.0),
                    // _buildPageTitle(context),
                    const SizedBox(height: 20.0),
                    Container(
                      height: 70.0,
                      child: _buildDateList,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildPageTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Text(
        'Emploi du temps',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget get _buildDateList => PageView.builder(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        itemCount: 53,
        itemBuilder: (BuildContext context, int index) {
          int week = DateTime(_getSchoolStartYear(), DateTime.september)
              .add(Duration(days: 7 * index))
              .week;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: StreamBuilder<Object>(
                stream: selectedDateBloc.subject.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Week(week: week, selectedDate: snapshot.data);
                  }
                  return SizedBox.shrink();
                }),
          );
        },
      );
}
