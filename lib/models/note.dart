import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final formatter = DateFormat('dd-MM-yyyy hh:mm a');

class Note {
  String id;
  String title;
  String content;
  DateTime time;

  Note({required this.title, required this.content, required this.time})
    : id = uuid.v4();

  Note.withId({
    required this.id,
    required this.title,
    required this.content,
    required this.time
  });

  String get formattedTime => formatter.format(time).toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': time.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note.withId(id: map['id'], title: map['title'], content: map['content'], time : DateTime.parse(map['timestamp']));
  }
}
