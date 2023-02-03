class HotlineCategoryModel {
  String? id;
  String? name;

  HotlineCategoryModel({this.id, this.name});

  HotlineCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
