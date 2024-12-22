// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
      result: json['result'] == null
          ? null
          : TicketResult.fromJson(json['result'] as Map<String, dynamic>),
      title: json['title'] as String,
      description: json['description'] as String,
      id: json['id'] as String?,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'result': instance.result?.toJson(),
      'link': instance.link,
    };
