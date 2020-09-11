import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iut_lr_app/services/gpu.dart';
import 'package:iut_lr_app/user.dart';

import '../apis/dateTime_apis.dart';
import '../apis/string_apis.dart';
import '../constants.dart';
import 'card/date_card.dart';

class NavBar extends StatefulWidget {
  final DateTime selectedDate;
  final Function onDateChanged;

  const NavBar({
    Key key,
    @required this.selectedDate,
    @required this.onDateChanged,
  }) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  PageController _pageController;
  Future<String> _studentName;
  int _selectedIndex;

  int schoolStartYear() {
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    return month >= DateTime.september && month <= DateTime.december
        ? year
        : year - 1;
  }

  bool isSelected(DateTime date) {
    return DateFormat.yMd().format(date) ==
        DateFormat.yMd().format(widget.selectedDate);
  }

  @override
  void initState() {
    super.initState();
    var diff = widget.selectedDate
            .difference(DateTime(schoolStartYear(), DateTime.september))
            .inDays /
        7;
    _selectedIndex = widget.selectedDate.weekday - 1;
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () => GpuService.logOut().then(
                      (_) => Navigator.pushReplacementNamed(context, '/login'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: FutureBuilder(
                  future: _studentName,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return snapshot.hasData
                        ? Text(
                            'Salut, ${snapshot.data.toTitleCase()}!',
                            style: kSubtitleStyle,
                          )
                        : SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  'Emploi du temps',
                  style: kLargeTitleStyle,
                ),
              ),
              const SizedBox(height: 25.0),
              Container(
                height: 70.0,
                child: _buildDateList,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildDateList =>
      PageView.builder(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        itemCount: 53,
        itemBuilder: (BuildContext context, int index) {
          int displayedWeek = DateTime(schoolStartYear(), DateTime.september)
              .add(Duration(days: 7 * index))
              .week;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Stack(
              children: [
                if (displayedWeek == widget.selectedDate.week)
                  _buildSelectedIndicator(context),
                _buildWeek(week: displayedWeek),
              ],
            ),
          );
        },
      );

  Widget _buildSelectedIndicator(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      left: (MediaQuery
          .of(context)
          .size
          .width - 60) / 7 * _selectedIndex,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: kOrangeColor,
        ),
        width: (MediaQuery
            .of(context)
            .size
            .width - 60) / 7,
        height: 70.0,
      ),
    );
  }

  Widget _buildWeek({int week}) {
    return Row(
      children: List.generate(7, (int index) {
        DateTime firstMondayOfWeek = getFirstMondayOfWeek(week: week);
        DateTime date = firstMondayOfWeek.add(Duration(days: index));
        return Expanded(
          child: DateCard(
            date: date,
            isSelected: isSelected(date),
            onTap: () {
              widget.onDateChanged(date);
              setState(() => _selectedIndex = index);
            },
          ),
        );
      }),
    );
  }

  DateTime getFirstMondayOfWeek({int week}) {
    DateTime date =
    DateTime(schoolStartYear()).add(Duration(days: (week - 1) * 7));
    return DateTime(date.year, date.month, date.day + (1 - date.weekday));
  }
}
