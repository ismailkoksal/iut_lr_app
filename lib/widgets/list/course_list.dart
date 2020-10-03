import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iut_lr_app/apis/dateTime_apis.dart';
import 'package:iut_lr_app/bloc/get_courses_bloc.dart';
import 'package:iut_lr_app/bloc/get_selected_date_bloc.dart';
import 'package:iut_lr_app/models/course.dart';
import 'package:iut_lr_app/models/course_response.dart';
import 'package:rxdart/rxdart.dart';

import '../card/course_card.dart';

class CourseList extends StatefulWidget {
  const CourseList({
    Key key,
  }) : super(key: key);

  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Course> _courses = [];
  DateTime _currentDateTime = DateTime.now();
  Timer _timer;

  Stream<List<Course>> _getSelectedDateCourses() {
    return Rx.combineLatest2(
        coursesBloc.subject.stream, selectedDateBloc.subject.stream,
        (CourseResponse courseResponse, DateTime selectedDate) {
      if (courseResponse != null) {
        return courseResponse.courses
            .where((course) =>
                DateFormat.yMd().format(course.dtstart.toLocal()) ==
                DateFormat.yMd().format(selectedDate))
            .toList();
      }
      return [];
    });
  }

  void _loadCourses() {
    _getSelectedDateCourses().switchMap((value) {
      _removeCourses();
      return Stream.fromIterable(value.asMap().entries)
          .interval(Duration(milliseconds: 150));
    }).listen((event) {
      _courses.insert(event.key, event.value);
      _listKey.currentState.insertItem(event.key);
    });
  }

  void _removeCourses() {
    for (var i = _courses.length - 1; i >= 0; i--) {
      _courses.removeAt(i);
      _listKey.currentState.removeItem(i, (context, animation) => null);
    }
  }

  bool _isInClass(Course course) {
    return _currentDateTime.isAfter(course.dtstart.toLocal()) &&
        _currentDateTime.isBefore(course.dtend.toLocal());
  }

  void _updateTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) => setState(() => _currentDateTime = DateTime.now()),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCourses();
    _updateTimer();
    selectedDateBloc.subject.stream
        .map((date) => date.week)
        .distinct()
        .listen((week) => coursesBloc.getCourses(week));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CourseResponse>(
        stream: coursesBloc.subject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AnimatedList(
              key: _listKey,
              initialItemCount: _courses.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: _buildItem,
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    Course course = _courses[index];
    return Padding(
      padding: EdgeInsets.only(
          top: course == _courses.first ? 30.0 : 0.0,
          bottom: course == _courses.last ? 40.0 : 0.0),
      child: SlideTransition(
        position: CurvedAnimation(
          curve: Curves.easeOut,
          parent: animation,
        ).drive((Tween<Offset>(
          begin: Offset(0, -1),
          end: Offset.zero,
        ))),
        child: FadeTransition(
          opacity: CurvedAnimation(curve: Curves.easeIn, parent: animation),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _buildCourseTime(course),
                const VerticalDivider(width: 20.0),
                _buildCourseCard(course),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(Course course) => Expanded(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: course == _courses.last ? 0.0 : 10.0),
          child: CourseCard(
            course: course,
            isActive: _isInClass(course),
          ),
        ),
      );

  Widget _buildCourseTime(Course course) => Container(
        width: 46.0,
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat.Hm().format(course.dtstart.toLocal()),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 5.0),
            Text(
              DateFormat.Hm().format(course.dtend.toLocal()),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      );
}
