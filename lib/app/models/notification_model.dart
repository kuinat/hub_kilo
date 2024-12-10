import 'dart:convert';

import 'package:get/get.dart';

import 'parents/model.dart';

class NotificationModel {
  String myId;
  String id;
  String title;
  String message;
  bool isSeen;
  bool disable;
  DateTime timestamp;

  NotificationModel(
      {this.id, this.title, this.message, this.isSeen, this.timestamp, this.myId, this.disable});

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] == null ? "00000-0000" : json['id'] as String,
        title: json['title'] == null ? "No title" : json['title'] as String,
        message:
        json['message'] == null ? "No data" : json['message'] as String,
        isSeen: json['isSeen'] == null ? false : json['isSeen'] as bool,
        disable: json['disable'] == null ? false : json['disable'] as bool,
        timestamp: json['timestamp'] == null
            ? DateTime.now()
            : DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id == null ? null : id,
      'title': title == null ? null : title,
      'message': message == null ? null : message,
      'isSeen': isSeen == null ? null : isSeen,
      'disable': disable == null ? null : disable,
      'timestamp': timestamp == null ? null : timestamp?.toIso8601String(),
    };
  }
}
