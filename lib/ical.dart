import 'dart:convert';

class ICAL {
  static const BEGIN = 'BEGIN';
  static const END = 'END';
  static const VEVENT = 'VEVENT';
  static const UID = 'UID';
  static const DTSTART = 'DTSTART'; // Date de début de l'événement
  static const DTEND = 'DTEND'; // Date de fin de l'événement
  static const SUMMARY = 'SUMMARY'; // Titre de l'événement
  static const LOCATION = 'LOCATION'; // Lieu de l'événement
  static const DESCRIPTION = 'DESCRIPTION'; // Description de l'événement

  static List<dynamic> icsToJson(String iCalendar) {
    final events = [];
    var currentEvent = {};

    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(iCalendar);

    description(v) {
      final pattern =
          RegExp(r'Salle:(?<Salle>.*) Prof:(?<Prof>.*) Spe:(?<Spe>.*)\\.*\\.*');

      final match = pattern.firstMatch(v);
      final map = {
        'Salle': match.namedGroup('Salle'),
        'Prof': match.namedGroup('Prof'),
        'Spe': Uri.decodeFull(match.namedGroup('Spe').replaceAll('=', '%'))
      };

      return map;
    }

    for (String line in lines) {
      final lineData = line.split(':');
      var key = lineData[0];
      var value = lineData.sublist(1).join(':');

      if (key.contains(';')) {
        final keyParts = key.split(';');
        key = keyParts[0];
      }

      switch (key) {
        case BEGIN:
          if (value == VEVENT) currentEvent = {};
          break;
        case UID:
          currentEvent['uid'] = value;
          break;
        case DESCRIPTION:
          currentEvent['description'] = description(value);
          break;
        case SUMMARY:
          currentEvent['summary'] = value;
          break;
        case LOCATION:
          currentEvent['location'] = value;
          break;
        case DTSTART:
          currentEvent['dtstart'] = value;
          break;
        case DTEND:
          currentEvent['dtend'] = value;
          break;
        case END:
          if (value == VEVENT) events.add(currentEvent);
          break;
      }
    }

    return jsonDecode(jsonEncode(events));
  }
}
