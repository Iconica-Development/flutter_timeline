class TimelineUser {
  const TimelineUser({
    required this.userId,
    this.firstName,
    this.lastName,
    this.imageUrl,
  });

  factory TimelineUser.fromJson(
    Map<String, dynamic> json,
    String userId,
  ) =>
      TimelineUser(
        userId: userId,
        firstName: json["first_name"] as String?,
        lastName: json["last_name"] as String?,
        imageUrl: json["image_url"] as String?,
      );

  final String userId;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "image_url": imageUrl,
      };

  String? get fullName {
    var fullName = "";

    if (firstName != null && lastName != null) {
      fullName += "$firstName $lastName";
    } else if (firstName != null) {
      fullName += firstName!;
    } else if (lastName != null) {
      fullName += lastName!;
    }

    return fullName == "" ? null : fullName;
  }
}
