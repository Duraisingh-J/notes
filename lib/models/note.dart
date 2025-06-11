import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final formatter = DateFormat('MM-EEE-yyyy hh:mm a');

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime time;

  Note({required this.title, required this.content, required this.time})
    : id = uuid.v4();

  String get formattedTime => formatter.format(time);
}
