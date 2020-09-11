import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/list/course_list.dart';
import '../widgets/navbar.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();

  void _onDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kBackgroundColor,
        child: Column(
          children: [
            NavBar(
              selectedDate: _selectedDate,
              onDateChanged: _onDateChanged,
            ),
            Expanded(
              child: CourseList(date: _selectedDate),
            ),
          ],
        ),
      ),
    );
  }
}
