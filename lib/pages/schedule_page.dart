import 'package:flutter/material.dart';

import '../widgets/list/course_list.dart';
import '../widgets/navbar.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final now = DateTime.now();
  DateTime _selectedDate;

  void _onDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            NavBar(
              selectedDate: _selectedDate,
              onDateChanged: (date) => _onDateChanged(date),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CourseList(selectedDate: _selectedDate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
