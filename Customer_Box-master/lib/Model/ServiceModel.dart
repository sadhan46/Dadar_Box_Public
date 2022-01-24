import 'package:json_annotation/json_annotation.dart';

part 'ServiceModel.g.dart';

@JsonSerializable()
class AddServiceModel {
  String businessName;
  String name;
  String cost;
  String hr;
  String min;
  int counter;
  bool addService;

  AddServiceModel(
      {
        required this.name,
        required this.cost,
        required this.businessName,
        required this.hr,
        required this.min,
        required this.counter,
        required this.addService,
      });

  factory AddServiceModel.fromJson(Map<String, dynamic> json) =>
      _$AddServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddServiceModelToJson(this);
}