class PersonalInfo {
  final String name;
  final String title;
  final String email;
  final String phone;
  final String location;

  const PersonalInfo({
    required this.name,
    required this.title,
    required this.email,
    required this.phone,
    required this.location,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'] as String,
      title: json['title'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
    );
  }
}