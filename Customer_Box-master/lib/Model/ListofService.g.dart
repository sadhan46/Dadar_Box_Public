// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListofService.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Services _$ServicesFromJson(Map<String, dynamic> json) {
  return Services(
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => AddServiceModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ServicesToJson(Services instance) => <String, dynamic>{
      'data': instance.data,
    };
