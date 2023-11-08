import 'dart:convert';

List<PrinterLabelDefinition> printerLabelDefinitionsFromJson(String str) => List<PrinterLabelDefinition>.from(json.decode(str).map((x) => PrinterLabelDefinition.fromJson(x)));

String printerLabelDefinitionsToJson(List<PrinterLabelDefinition> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrinterLabelDefinition {
  final String description;
  final List<String> tagType;
  final String condition;
  final List<String> labelDefinition;

  PrinterLabelDefinition({
    required this.description,
    required this.tagType,
    required this.condition,
    required this.labelDefinition,
  });

  factory PrinterLabelDefinition.fromJson(Map<String, dynamic> json) => PrinterLabelDefinition(
    description: json["Description"],
    tagType: List<String>.from(json["TagType"].map((x) => x)),
    condition: json["Condition"] ?? '',
    labelDefinition: List<String>.from(json["LabelDefinition"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Description": description,
    "TagType": List<dynamic>.from(tagType.map((x) => x)),
    "Condition": condition,
    "LabelDefinition": List<dynamic>.from(labelDefinition.map((x) => x)),
  };
}
