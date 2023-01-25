class ReportModel {
  String? userId;
  String? type;
  String? userAgent;
  String? description;
  String? latitude;
  String? longitude;
  String? address;
  String? updatedAt;
  String? createdAt;
  String? id;
  String? status;

  ReportModel(
      {this.userId,
        this.type,
        this.description,
        this.userAgent,
        this.latitude,
        this.longitude,
        this.address,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.status});

  ReportModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'].toString();
    type = json['type'].toString();
    description = json['description'];
    userAgent = json['useragent'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'].toString();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['description'] = this.description;
    data['useragent'] = this.userAgent;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}
