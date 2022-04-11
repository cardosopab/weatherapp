// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Office _$OfficeFromJson(Map<String, dynamic> json) => Office(
      properties: json['properties'] == null
          ? null
          : Properties.fromJson(json['properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OfficeToJson(Office instance) => <String, dynamic>{
      'properties': instance.properties,
    };
