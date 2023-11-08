// import 'dart:convert';
// import 'dart:math';
//
// import 'category_keys.dart';
//
// CategoryDetailModel categoryDetailModelFromJson(String str) => CategoryDetailModel().fromMap(json.decode(str));
//
// String categoryDetailModelToJson(CategoryDetailModel data) => json.encode(data.toMap());
//
// class CategoryDetailModel {
//
//   CategoryDetailModel({
//     this.id,
//     this.divisionId,
//     this.deptId,
//     this.classId,
//     this.categoryId,
//     this.categoryName,
//     this.season,
//     this.ladderPlan,
//     this.quantity,
//     this.description,
//     this.primaryKey,
//     this.price = 0.0,
//     this.style,
//     this.sgmPrice = '',
//     this.week
//   });
//
//   int? id;
//   String? divisionId;
//   String? deptId;
//   String? classId;
//   String? categoryId;
//   String? categoryName;
//   String? season;
//   String? ladderPlan;
//   int? quantity;
//   String? description;
//   int? primaryKey;
//   double price;
//   String? style;
//   String sgmPrice;
//   int? week;
//
//   Map<String, dynamic> toMap({bool isID = false}) {
//     Map<String, dynamic> map = {};
//     map[CategoryKeys.categoryPrimaryKey] = id;
//     if(isID){
//       map[CategoryKeys.id] = id;
//     }
//     map[CategoryKeys.divisionID] = divisionId;
//     map[CategoryKeys.departmentID] = deptId;
//     map[CategoryKeys.classID] = classId;
//     map[CategoryKeys.categoryID] = categoryId ?? divisionId;
//     map[CategoryKeys.categoryName] = categoryName;
//     map[CategoryKeys.season] = season ?? "";
//     map[CategoryKeys.ladderPlan] = ladderPlan ?? "";
//     map[CategoryKeys.quantity] = quantity ?? 0;
//     map[CategoryKeys.categoryDescription] = description ?? '';
//     map[CategoryKeys.week] = week ?? 0;
//     return map;
//   }
//
//   CategoryDetailModel fromMap(Map<String, dynamic> json) {
//     var model = CategoryDetailModel();
//     model.primaryKey = json[CategoryKeys.categoryPrimaryKey] ?? json[CategoryKeys.id];
//     model.id = json[CategoryKeys.id];
//     model.divisionId = json[CategoryKeys.divisionID];
//     model.deptId = json[CategoryKeys.departmentID];
//     model.classId = json[CategoryKeys.classID] ?? json["cassId"];
//     model.categoryId = json[CategoryKeys.categoryID];
//     model.categoryName = json[CategoryKeys.categoryName];
//     model.season = json[CategoryKeys.season];
//     model.ladderPlan = json[CategoryKeys.ladderPlan];
//     model.quantity = json[CategoryKeys.quantity] ?? 0;
//     model.description = json[CategoryKeys.categoryDescription] ?? "";
//     model.price = Random().nextInt(200) + [0.00, 0.99][Random().nextInt(2)];
//     model.week = json[CategoryKeys.week] ?? 0;
//     return model;
//   }
// }
