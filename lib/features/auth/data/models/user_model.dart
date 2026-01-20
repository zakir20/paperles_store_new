class UserModel {
  final int userId;
  final String name;
  final String email;
  final String phone;
  final String role;
  final int shopId;
  final String shopName;
  final String shopCategory;
  final String shopLogo;
  final String accessToken;
  final String userProfilePic;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.shopId,
    required this.shopName,
    required this.shopCategory,
    required this.shopLogo,
    required this.accessToken,
    required this.userProfilePic,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
      userId: _parseInt(json?['user_id']),
      name: json?['name']?.toString() ?? '',
      email: json?['email']?.toString() ?? '',
      phone: json?['phone']?.toString() ?? '',
      role: json?['role']?.toString() ?? '',
      shopId: _parseInt(json?['shop_id']),
      shopName: json?['shop_name']?.toString() ?? '',
      shopCategory: json?['shop_category']?.toString() ?? '',
      shopLogo: json?['shop_logo_mobile']?.toString() ?? '',
      accessToken: json?['access_token']?.toString() ?? '',
      userProfilePic: json?['profile_pic_mobile']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'shop_id': shopId,
      'shop_name': shopName,
      'shop_category': shopCategory,
      'shop_logo_mobile': shopLogo,
      'access_token': accessToken,
      'profile_pic_mobile': userProfilePic,
    };
  }

  @override
  String toString() {
    return 'UserData(userId: $userId, name: $name, email: $email, phone: $phone, role: $role, shopId: $shopId, shopName: $shopName, shopCategory: $shopCategory, shopLogo: $shopLogo, accessToken: $accessToken)';
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
