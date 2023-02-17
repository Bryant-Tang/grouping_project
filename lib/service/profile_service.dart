import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String email;
  final String username;

  UserProfile({this.email = 'unknown', this.username = 'unknown'});

  factory UserProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return UserProfile(
      email: data?['email'],
      username: data?['name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "email": email,
      "name": username,
    };
  }
}

Future<void> setProfile(
    {required UserProfile newProfile, required String userId}) async {
  final profileLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(userId)
      .collection("profile")
      .doc('profile')
      .withConverter(
        fromFirestore: UserProfile.fromFirestore,
        toFirestore: (UserProfile profile, options) => profile.toFirestore(),
      );
  await profileLocation.set(newProfile);
  return;
}

Future<UserProfile?> getProfile({required String userId}) async {
  final profileLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(userId)
      .collection("profile")
      .doc('profile')
      .withConverter(
        fromFirestore: UserProfile.fromFirestore,
        toFirestore: (UserProfile profile, options) => profile.toFirestore(),
      );
  final profileSnap = await profileLocation.get();
  return profileSnap.data();
}
