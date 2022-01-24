// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ServiceModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddServiceModel _$AddServiceModelFromJson(Map<String, dynamic> json) {
  return AddServiceModel(
    name: json['name'] as String,
    cost: json['cost'] as String,
    businessName: json['businessName'] as String,
    hr: json['hr'] as String,
    min: json['min'] as String,
    counter: json['counter'] as int,
    addService: json['addService'] as bool,
  );
}

Map<String, dynamic> _$AddServiceModelToJson(AddServiceModel instance) =>
    <String, dynamic>{
      'businessName': instance.businessName,
      'name': instance.name,
      'cost': instance.cost,
      'hr': instance.hr,
      'min': instance.min,
      'counter': instance.counter,
      'addService': instance.addService,
    };
