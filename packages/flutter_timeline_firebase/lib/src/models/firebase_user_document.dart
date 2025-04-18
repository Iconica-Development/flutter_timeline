// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class FirebaseUserDocument {
  const FirebaseUserDocument({
    this.firstName,
    this.lastName,
    this.imageUrl,
    this.userId,
  });

  FirebaseUserDocument.fromJson(
    Map<String, Object?> json,
    String userId,
  ) : this(
          userId: userId,
          firstName: json['first_name'] as String?,
          lastName: json['last_name'] as String?,
          imageUrl: json['image_url'] as String?,
        );

  final String? firstName;
  final String? lastName;
  final String? imageUrl;
  final String? userId;

  Map<String, Object?> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'image_url': imageUrl,
      };
}
