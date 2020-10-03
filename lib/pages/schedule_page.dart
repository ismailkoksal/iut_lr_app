import 'package:flutter/material.dart';

import '../widgets/list/course_list.dart';
import '../widgets/navbar.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          NavBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CourseList(),
            ),
          ),
        ],
      ),
    );
  }
}
