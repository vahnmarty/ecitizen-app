class Directory {
  String? id;
  String? name;
  String? address;
  String? barangay;
  String? telephone;
  String? cellphone;
  String? email;
  String? facebookUrl;
  String? facebookUsername;
  String? twitterUrl;
  String? twitterUsername;
  String? instagramUrl;
  String? instagramUsername;
  String? tiktokUrl;
  String? tiktokUsername;
  String? createdAt;
  String? updatedAt;

  Directory(
      {this.id,
        this.name,
        this.address,
        this.barangay,
        this.telephone,
        this.cellphone,
        this.email,
        this.facebookUrl,
        this.facebookUsername,
        this.twitterUrl,
        this.twitterUsername,
        this.instagramUrl,
        this.instagramUsername,
        this.tiktokUrl,
        this.tiktokUsername,
        this.createdAt,
        this.updatedAt});

  Directory.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    address = json['address'];
    barangay = json['barangay'];
    telephone = json['telephone'];
    cellphone = json['cellphone'];
    email = json['email'];
    facebookUrl = json['facebook_url'];
    facebookUsername = json['facebook_username'];
    twitterUrl = json['twitter_url'];
    twitterUsername = json['twitter_username'];
    instagramUrl = json['instagram_url'];
    instagramUsername = json['instagram_username'];
    tiktokUrl = json['tiktok_url'];
    tiktokUsername = json['tiktok_username'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['barangay'] = this.barangay;
    data['telephone'] = this.telephone;
    data['cellphone'] = this.cellphone;
    data['email'] = this.email;
    data['facebook_url'] = this.facebookUrl;
    data['facebook_username'] = this.facebookUsername;
    data['twitter_url'] = this.twitterUrl;
    data['twitter_username'] = this.twitterUsername;
    data['instagram_url'] = this.instagramUrl;
    data['instagram_username'] = this.instagramUsername;
    data['tiktok_url'] = this.tiktokUrl;
    data['tiktok_username'] = this.tiktokUsername;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
