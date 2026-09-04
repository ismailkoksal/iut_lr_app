import 'package:iut_lr_app/models/course.dart';

class CourseResponse {
  /// Numéro de semaine demandé à gpu2vcs.php. L'API ne prend pas d'année et
  /// renvoie la semaine de l'année scolaire qu'elle a en base pour l'étudiant,
  /// qui n'est pas forcément l'année courante — on garde donc la semaine
  /// demandée pour rattacher la réponse à la date sélectionnée.
  final int week;
  final List<Course> courses;

  CourseResponse(this.week, List<dynamic> json)
      : courses = json.map((e) => Course.fromJson(e)).toList();
}
