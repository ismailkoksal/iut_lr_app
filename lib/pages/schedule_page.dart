import 'package:flutter/material.dart';
import 'package:iut_lr_app/widgets/list/course_list.dart';

import '../widgets/navbar.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
