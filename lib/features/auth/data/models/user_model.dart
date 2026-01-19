class UserModel {
  final String? name;
  final String? email;
  final String? phone;
  final String? password;
  final String? shopName;
  final String? proprietorName;
  final String? shopType;
  final String? address;
  final String? tradeLicense;
  final String? profileImagePath;
  final String? tradeLicensePath;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.shopName,
    this.proprietorName,
    this.shopType,
    this.address,
    this.tradeLicense,
    this.profileImagePath,
    this.tradeLicensePath,
  });

  //  fromJson: Converts PHP JSON response into UserModel Object
  // Use this when  fetch user profile data from the database
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      shopName: json['shop_name'],
      proprietorName: json['proprietor_name'],
      shopType: json['shop_type'],
      address: json['address'],
      tradeLicense: json['trade_license'],
      profileImagePath: json['profile_pic'], 
      tradeLicensePath: json['trade_license_pic'],
    );
  }

  //  toJson: Converts UserModel into a Map for the POST request
  // These KEYS match  PHP $_POST['key'] 
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'shop_name': shopName,
      'proprietor_name': proprietorName,
      'shop_type': shopType,
      'address': address,
      'trade_license': tradeLicense,
      'source': 'app', 
    };
  }
}