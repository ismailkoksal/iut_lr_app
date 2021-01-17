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
    DateTime date = DateTime(1900).add(Duration(days: (week - 1) * 7));
    return DateTime(date.year, date.month, date.day + (1 - date.weekday));
  }

  bool isSelected(DateTime date) {
    return DateFormat.yMd().format(date) ==
        DateFormat.yMd().format(selectedDateBloc.subject.value);
  }

  @override
  void initState() {
    super.initState();
    var diff = selectedDateBloc.subject.value
                .difference(_getFirstMondayOfWeek(week: DateTime(1900).week))
                .inDays /
            7 +
        0.1;
    _pageController = PageController(initialPage: diff.ceil());
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
                      child: FutureBuilder<String>(
                        future: _studentName,
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? Text(
                                  'Salut, ${snapshot.data.toTitleCase()}!',
                                  style: Theme.of(context).textTheme.headline6,
                                )
                              : _buildPageTitle(context);
                        },
                      ),
                    ),
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

  Widget _buildPageTitle(BuildContext context) {
    return Text(
      'Emploi du temps',
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget get _buildDateList => PageView.builder(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        itemBuilder: (context, index) {
          DateTime date = DateTime(1900).add(Duration(days: 7 * index));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: StreamBuilder<DateTime>(
              stream: selectedDateBloc.subject.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Week(
                      week: date.week,
                      year: date.year,
                      selectedDate: snapshot.data);
                }
                return SizedBox.shrink();
              },
            ),
          );
        },
      );
}
