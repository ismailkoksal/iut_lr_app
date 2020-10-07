import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

import '../../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isActive;

  const CourseCard({
    Key key,
    @required this.course,
    this.isActive = false,
  })  : assert(course != null),
        assert(isActive != null),
        super(key: key);

  Color _getCardBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    return isActive ? theme.indicatorColor : theme.cardColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: _getCardBackgroundColor(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.description.spe,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: isActive ? Colors.white : null,
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (course.description.salle != '') _buildClassRoom(context),
                  if (course.description.prof != '') _buildTeacher(context),
                ],
              ),
              Container(
                decoration: ShapeDecoration(
                  color: _getCardBackgroundColor(context).darken(),
                  shape: StadiumBorder(),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                height: 32,
                alignment: Alignment.center,
                child: Text(
                  course.summary.split(' / ')[1],
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacher(BuildContext context) => Column(
        children: [
          const SizedBox(height: 5.0),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 18.0,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyText1.color,
              ),
              const SizedBox(width: 10.0),
              Text(
                course.description.prof,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: isActive ? Colors.white : null,
                    ),
              ),
            ],
          ),
        ],
      );

  Widget _buildClassRoom(BuildContext context) => Column(
        children: [
          const SizedBox(height: 15.0),
          Row(
            children: [
              Icon(
                Icons.place,
                size: 18.0,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyText1.color,
              ),
              const SizedBox(width: 10.0),
              Text(
                course.description.salle,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: isActive ? Colors.white : null,
                    ),
              ),
            ],
          ),
        ],
      );
}
