// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  senderUID: json['senderUID'] as String,
  content: json['content'] as String,
  timestamp: const TimestampConverter().fromJson(json['timestamp']),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'senderUID': instance.senderUID,
  'content': instance.content,
  'timestamp': const TimestampConverter().toJson(instance.timestamp),
};
