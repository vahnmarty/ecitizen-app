class ServiceModel {
  String? id;
  String? name;

  ServiceModel({this.id, this.name});

  ServiceModel.fromJson(Map<String, dynamic> json) {
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
class BusinessServiceModel {
  String? id;
  String? name;
  String? applicationForm;
  String? filePreview;
  String? createdAt;
  String? updatedAt;
  String? applicationFormUrl;
  String? filePreviewUrl;
  List<Requirements>? requirements;
  List<Procedures>? procedures;

  BusinessServiceModel(
      {this.id,
        this.name,
        this.applicationForm,
        this.filePreview,
        this.createdAt,
        this.updatedAt,
        this.applicationFormUrl,
        this.filePreviewUrl,
        this.requirements,
        this.procedures});

  BusinessServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    applicationForm = json['application_form'];
    filePreview = json['file_preview'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    applicationFormUrl = json['application_form_url'];
    filePreviewUrl = json['file_preview_url'];
    if (json['requirements'] != null) {
      requirements = <Requirements>[];
      json['requirements'].forEach((v) {
        requirements!.add(new Requirements.fromJson(v));
      });
    }
    if (json['procedures'] != null) {
      procedures = <Procedures>[];
      json['procedures'].forEach((v) {
        procedures!.add(new Procedures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['application_form'] = this.applicationForm;
    data['file_preview'] = this.filePreview;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['application_form_url'] = this.applicationFormUrl;
    data['file_preview_url'] = this.filePreviewUrl;
    if (this.requirements != null) {
      data['requirements'] = this.requirements!.map((v) => v.toJson()).toList();
    }
    if (this.procedures != null) {
      data['procedures'] = this.procedures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Requirements {
  String? id;
  String? serviceId;
  String? title;
  String? content;
  String? createdAt;
  String? updatedAt;
  String? filePreviewUrl;
  List<String>? media;

  Requirements(
      {this.id,
        this.serviceId,
        this.title,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.filePreviewUrl,
        this.media});

  Requirements.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    serviceId = json['service_id'].toString();
    title = json['title'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    filePreviewUrl = json['file_preview_url'];
    if (json['media'] != null) {
      media = <String>[];
      json['media'].forEach((v) {
        //media!.add(new v.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_id'] = this.serviceId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['file_preview_url'] = this.filePreviewUrl;
    if (this.media != null) {
      //data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Procedures {
  int? id;
  int? serviceId;
  String? title;
  String? content;
  String? createdAt;
  String? updatedAt;
  Null? filePreviewUrl;

  Procedures(
      {this.id,
        this.serviceId,
        this.title,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.filePreviewUrl});

  Procedures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    title = json['title'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    filePreviewUrl = json['file_preview_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_id'] = this.serviceId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['file_preview_url'] = this.filePreviewUrl;
    return data;
  }
}

