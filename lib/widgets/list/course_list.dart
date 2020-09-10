import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iut_lr_app/models/course.dart';
import 'package:iut_lr_app/user.dart';

import '../../constants.dart';
import '../../services/gpu.dart';
import '../card/course_card.dart';

class CourseList extends StatefulWidget {
  final DateTime date;
  final int week;

  const CourseList({
    Key key,
    @required this.date,
    @required this.week,
  }) : super(key: key);

  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> with WidgetsBindingObserver {
  Future<List<Course>> _coursesFuture;
  DateTime _currentDateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _coursesFuture = GpuService.getSchedule(week: widget.week);
    _timer = Timer.periodic(Duration(seconds: 1),
        (timer) => setState(() => _currentDateTime = DateTime.now()));
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      bool isLoggedIn = await GpuService.isLoggedIn();
      if (!isLoggedIn) {
        GpuService.login(studentId: await User.studentId).then((isLoggedIn) => {
              if (isLoggedIn)
                _coursesFuture = GpuService.getSchedule(week: widget.week)
            });
      }
    }
  }

  @override
  void didUpdateWidget(CourseList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.week != widget.week) {
      _coursesFuture = GpuService.getSchedule(week: widget.week);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  List<Course> getCoursesByDate(List<Course> courses) {
    courses.sort((a, b) => a.dtstart.compareTo(b.dtend));
    return courses
        .where((course) =>
            DateFormat.yMd().format(course.dtstart) ==
            DateFormat.yMd().format(widget.date))
        .toList();
  }

  bool isCurrentCourse(Course course) {
    return _currentDateTime.isAfter(course.dtstart.toLocal()) &&
        _currentDateTime.isBefore(course.dtend.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FutureBuilder(
        future: _coursesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Course>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            List<Course> courses = getCoursesByDate(snapshot.data);
            if (courses.isNotEmpty) {
              return _buildSchedule(courses);
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tu n'as pas cours ce jour là !",
                    style: kSubtitleStyle,
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildSchedule(List<Course> courses) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (BuildContext context, int index) {
        return IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 50.0,
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.Hm().format(courses[index].dtstart.toLocal()),
                      style: kSecondaryCalloutLabelStyle,
                    ),
                    Text(
                      DateFormat.Hm().format(courses[index].dtend.toLocal()),
                      style: kSecondaryCalloutLabelStyle,
                    ),
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 3,
                color: Colors.black.withOpacity(0.03),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: CourseCard(
                    course: courses[index],
                    isActive: isCurrentCourse(courses[index]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
