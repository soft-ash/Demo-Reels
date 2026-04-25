class ReelUser {
  const ReelUser({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.image,
  });

  final String id;
  final String fullName;
  final String userName;
  final String? image;

  factory ReelUser.fromJson(Map<String, dynamic> json) {
    return ReelUser(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? 'Unknown user',
      userName: json['userName'] as String? ?? 'unknown',
      image: json['image'] as String?,
    );
  }
}
