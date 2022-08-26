// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? dates;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task(
      {this.id,
      required this.title,
      required this.note,
      required this.isCompleted,
      required this.dates,
      required this.startTime,
      required this.endTime,
      required this.color,
      required this.remind,
      required this.repeat});

  Map<String, dynamic> toJson() {
    return {
      /*'id': id,*/
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'dates': dates,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat,
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    dates = json['dates'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    color = json['color'];
    remind = json['remind'];
    repeat = json['repeat'];
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, note: $note, isCompleted: $isCompleted, dates: $dates, startTime: $startTime, endTime: $endTime, color: $color, remind: $remind, repeat: $repeat)';
  }
}
