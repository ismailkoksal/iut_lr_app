import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isActive;

  const CourseCard({
    Key key,
    @required this.course,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: isActive ? kGreenColor : kCardPopupBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.description.spe,
            style: kHeadlineLabelStyle.copyWith(
              color: isActive ? Colors.white : null,
            ),
          ),
          if (course.description.salle != '') _buildClassRoom,
          if (course.description.prof != '') _buildTeacher,
        ],
      ),
    );
  }

  Widget get _buildTeacher => Column(
        children: [
          const SizedBox(height: 5.0),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 18.0,
                color: isActive ? Colors.white : kSubtitleStyle.color,
              ),
              const SizedBox(width: 10.0),
              Text(
                course.description.prof,
                style: kSubtitleStyle.copyWith(
                  color: isActive ? Colors.white : null,
                ),
              ),
            ],
          ),
        ],
      );

  Widget get _buildClassRoom => Column(
        children: [
          const SizedBox(height: 15.0),
          Row(
            children: [
              Icon(
                Icons.place,
                size: 18.0,
                color: isActive ? Colors.white : kSubtitleStyle.color,
              ),
              const SizedBox(width: 10.0),
              Text(
                course.description.salle,
                style: kSubtitleStyle.copyWith(
                  color: isActive ? Colors.white : null,
                ),
              ),
            ],
          ),
        ],
      );
}
