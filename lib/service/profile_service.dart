import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String email;
  final String userName;
  final String userId;

  UserProfile({
    this.userId = '',
    this.email = 'unknown',
    this.userName = 'unknown',
  });

  factory UserProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return UserProfile(
      email: data?['email'],
      userName: data?['name'],
      userId: data?['id'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != 'unknown') "email": email,
      if (userName != 'unknown') "name": userName,
      if (userId != '') "id": userId,
    };
  }
}

class GroupProfile {
  final String userName;
  final String userId;

  GroupProfile({
    this.userId = '',
    this.userName = 'unknown',
  });

  factory GroupProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return GroupProfile(
      userName: data?['name'],
      userId: data?['id'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userName != 'unknown') "name": userName,
      if (userId != '') "id": userId,
    };
  }
}

Future<void> setProfileForPerson(
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
  await profileLocation.set(newProfile, SetOptions(merge: true));
  return;
}

Future<void> setProfileForGroup(
    {required GroupProfile newProfile, required String groupId}) async {
  final profileLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(groupId)
      .collection("profile")
      .doc('profile')
      .withConverter(
        fromFirestore: GroupProfile.fromFirestore,
        toFirestore: (GroupProfile profile, options) => profile.toFirestore(),
      );
  await profileLocation.set(newProfile, SetOptions(merge: true));
  return;
}

Future<UserProfile?> getProfileForPerson({required String userId}) async {
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

Future<GroupProfile?> getProfileForGroup({required String groupId}) async {
  final profileLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(groupId)
      .collection("profile")
      .doc('profile')
      .withConverter(
        fromFirestore: GroupProfile.fromFirestore,
        toFirestore: (GroupProfile profile, options) => profile.toFirestore(),
      );
  final profileSnap = await profileLocation.get();
  return profileSnap.data();
}

// Future<String?> getUserId({required String email}) async {
//   final profileLocation = FirebaseFirestore.instance
//       .collectionGroup("profile")
//       .where('email', isEqualTo: email)
//       .withConverter(
//         fromFirestore: UserProfile.fromFirestore,
//         toFirestore: (UserProfile profile, options) => profile.toFirestore(),
//       );
//   final profileSnap = await profileLocation.get();
//   if (profileSnap.docs.length == 1) {
//     return profileSnap.docs[0].data().userId;
//   } else {
//     return null;
//   }
// }

Future<Map<String, String>> getGroupList({required String userId}) async {
  final groupsLocation = FirebaseFirestore.instance
      .collection('group_properties')
      .doc(userId)
      .collection('groups');
  final groupListSnap = await groupsLocation.get();
  Map<String, String> groupList = {};
  for (var groupSnap in groupListSnap.docs) {
    groupList.addAll(
        {groupSnap.id: groupSnap.data()['name'] as String});
  }
  return groupList;
}
