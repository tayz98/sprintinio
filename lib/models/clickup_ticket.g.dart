// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clickup_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClickUpTicket _$ClickUpTicketFromJson(Map<String, dynamic> json) =>
    ClickUpTicket(
      title: json['title'] as String,
      description: json['description'] as String,
      link: json['link'] as String?,
      result: json['result'] == null
          ? null
          : TicketResult.fromJson(json['result'] as Map<String, dynamic>),
      id: json['id'] as String?,
      clickUpId: json['clickUpId'] as String,
    );

Map<String, dynamic> _$ClickUpTicketToJson(ClickUpTicket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'result': instance.result?.toJson(),
      'link': instance.link,
      'clickUpId': instance.clickUpId,
    };
