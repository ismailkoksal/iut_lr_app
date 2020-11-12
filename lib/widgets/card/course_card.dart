import 'package:flutter/material.dart';
import 'package:iut_lr_app/themes/colors.dart';

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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (course.description.salle != '')
                    _buildSubtitle(
                        context, Icons.place, course.description.salle),
                  if (course.description.prof != '')
                    _buildSubtitle(
                        context, Icons.person, course.description.prof),
                ],
              ),
              Container(
                decoration: ShapeDecoration(
                  color: CustomColor.darkBlue[600],
                  shape: StadiumBorder(),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                height: 32,
                alignment: Alignment.center,
                child: Text(course.summary.split(' / ')[1],
                    style: Theme.of(context).chipTheme.labelStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, IconData icon, String text) =>
      Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: isActive ? Colors.white : null,
          ),
          const SizedBox(width: 10.0),
          Text(
            text,
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  color: isActive ? Colors.white : null,
                ),
          ),
        ],
      );
}
