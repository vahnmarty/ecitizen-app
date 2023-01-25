class News {
  String? id;
  String? userId;
  String? title;
  String? shortDescription;
  String? contents;
  String? status;
  String? type;
  String? thumbnail;
  String? publishedAt;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  News(
      {this.id,
        this.userId,
        this.title,
        this.shortDescription,
        this.contents,
        this.status,
        this.type,
        this.thumbnail,
        this.publishedAt,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    title = json['title'];
    shortDescription = json['short_description'];
    contents = json['contents'];
    status = json['status'];
    type = json['type'].toString();
    thumbnail = json['thumbnail'];
    publishedAt = json['published_at'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['short_description'] = this.shortDescription;
    data['contents'] = this.contents;
    data['status'] = this.status;
    data['type'] = this.type;
    data['thumbnail'] = this.thumbnail;
    data['published_at'] = this.publishedAt;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
