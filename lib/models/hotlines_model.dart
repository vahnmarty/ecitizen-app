class HotlinesModel {
  String? id;
  String? hotlineCategory;
  String? name;
  String? createdAt;
  String? updatedAt;
  List<Numbers>? numbers;

  HotlinesModel(
      {this.id,
        this.hotlineCategory,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.numbers});

  HotlinesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    hotlineCategory = json['hotline_category'].toString();
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['numbers'] != null) {
      numbers = <Numbers>[];
      json['numbers'].forEach((v) {
        numbers!.add(new Numbers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hotline_category'] = this.hotlineCategory;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.numbers != null) {
      data['numbers'] = this.numbers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Numbers {
  String? id;
  String? hotlineId;
  String? phoneType;
  String? number;
  String? createdAt;
  String? updatedAt;

  Numbers(
      {this.id,
        this.hotlineId,
        this.phoneType,
        this.number,
        this.createdAt,
        this.updatedAt});

  Numbers.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    hotlineId = json['hotline_id'].toString();
    phoneType = json['phone_type'].toString();
    number = json['number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hotline_id'] = this.hotlineId;
    data['phone_type'] = this.phoneType;
    data['number'] = this.number;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
