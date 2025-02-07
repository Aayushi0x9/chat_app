import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String msg;
  String sender;
  String receiver;
  Timestamp time;

  ChatModel({
    required this.msg,
    required this.sender,
    required this.receiver,
    required this.time,
  });

  factory ChatModel.fromMap({required Map<String, dynamic> data}) => ChatModel(
        msg: data['msg'],
        sender: data['sender'],
        receiver: data['receiver'],
        time: data['time'],
      );

  Map<String, dynamic> get toMap => {
        'msg': msg,
        'sender': sender,
        'receiver': receiver,
        'time': time,
      };
}
