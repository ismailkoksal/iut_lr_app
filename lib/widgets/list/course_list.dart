import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iut_lr_app/models/course.dart';
import 'package:iut_lr_app/user.dart';
import 'package:rxdart/rxdart.dart';

import '../../apis/dateTime_apis.dart';
import '../../services/gpu.dart';
import '../card/course_card.dart';

class CourseList extends StatefulWidget {
  final DateTime selectedDate;

  const CourseList({
    Key key,
    @required this.selectedDate,
  }) : super(key: key);

  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> with WidgetsBindingObserver {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Course> _courses = [];
  Future<List<Course>> _coursesFuture;
  DateTime _currentDateTime = DateTime.now();
  Timer _timer;
  StreamSubscription<Course> _stream;
  bool _isLoading = false;

  List<Course> _getCoursesByDate(List<Course> courses) {
    courses.sort((a, b) => a.dtstart.compareTo(b.dtend));
    return courses
        .where((course) =>
            DateFormat.yMd().format(course.dtstart) ==
            DateFormat.yMd().format(widget.selectedDate))
        .toList();
  }

  void _loadCourses() async {
    List<Course> courses = await _coursesFuture;
    List<Course> selectedDateCourses = _getCoursesByDate(courses);

    _stream = Stream.fromIterable(selectedDateCourses)
        .interval(Duration(milliseconds: 150))
        .listen((course) {
      final int i = selectedDateCourses.indexOf(course);
      _courses.insert(i, selectedDateCourses[i]);
      _listKey.currentState.insertItem(i);
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _coursesFuture = GpuService.getSchedule(week: widget.selectedDate.week);
    _timer = Timer.periodic(Duration(seconds: 1),
        (timer) => setState(() => _currentDateTime = DateTime.now()));
    _loadCourses();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      bool isLoggedIn = await GpuService.isLoggedIn();
      if (!isLoggedIn) {
        GpuService.login(studentId: await User.studentId).then((isLoggedIn) => {
              if (isLoggedIn)
                _coursesFuture =
                    GpuService.getSchedule(week: widget.selectedDate.week)
            });
      }
    }
  }

  @override
  void didUpdateWidget(CourseList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate.week != widget.selectedDate.week) {
      _isLoading = true;
      _coursesFuture = GpuService.getSchedule(week: widget.selectedDate.week)
          .whenComplete(() => _isLoading = false);
    }
    if (oldWidget.selectedDate != widget.selectedDate) {
      _stream.cancel();
      _removeCourses();
      _loadCourses();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : AnimatedList(
            key: _listKey,
            initialItemCount: _courses.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: _buildItem,
          );
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
          begin: Offset(0, -0.3),
          end: Offset.zero,
        ))),
        child: FadeTransition(
          opacity: CurvedAnimation(curve: Curves.easeOut, parent: animation),
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
