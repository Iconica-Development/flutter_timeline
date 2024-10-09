import "package:firebase_auth/firebase_auth.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class FirebaseUserRepository implements TimelineUserRepositoryInterface {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  @override
  Future<List<TimelineUser>> getAllUsers() async {
    var users = await usersCollection
        .withConverter<TimelineUser>(
          fromFirestore: (snapshot, _) =>
              TimelineUser.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (user, _) => user.toJson(),
        )
        .get();
    return users.docs.map((e) => e.data()).toList();
  }

  @override
  Future<TimelineUser> getCurrentUser() async {
    var authUser = FirebaseAuth.instance.currentUser;
    var user = await usersCollection
        .doc(authUser!.uid)
        .withConverter<TimelineUser>(
          fromFirestore: (snapshot, _) =>
              TimelineUser.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (user, _) => user.toJson(),
        )
        .get();
    return user.data()!;
  }

  @override
  Future<TimelineUser?> getUser(String userId) async {
    var userDoc = await usersCollection
        .doc(userId)
        .withConverter<TimelineUser>(
          fromFirestore: (snapshot, _) =>
              TimelineUser.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (user, _) => user.toJson(),
        )
        .get();
        // print(userDoc.data()?.firstName);
    return userDoc.data();
  }
}
