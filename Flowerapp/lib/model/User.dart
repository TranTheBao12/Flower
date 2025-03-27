class UserProfile {
  final String id;
  final String userName;
  final String email;
  final String? initials;
  final String? phoneNumber;
  final String securityStamp;

  UserProfile({
    required this.id,
    required this.userName,
    required this.email,
    this.initials,
    this.phoneNumber,
    required this.securityStamp,
  });

  // fromJson constructor
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['data']['id'],  // Dữ liệu nằm trong trường 'data'
      userName: json['data']['userName'],
      email: json['data']['email'],
      initials: json['data']['initials'],
      phoneNumber: json['data']['phoneNumber'],
      securityStamp: json['data']['securityStamp'],
    );
  }
}
