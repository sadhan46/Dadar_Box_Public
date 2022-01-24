import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Model/ServiceModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ListofService.g.dart';

@JsonSerializable()
class Services {
  List<AddServiceModel>? data;
  Services({this.data});
  factory Services.fromJson(Map<String, dynamic> json) =>
      _$ServicesFromJson(json);
  Map<String, dynamic> toJson() => _$ServicesToJson(this);
}