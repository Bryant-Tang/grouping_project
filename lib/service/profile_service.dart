import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String? email;
  final String? userName;
  final String? userColor;
  String userId = '';

  UserProfile({
    this.email,
    this.userName,
    this.userColor,
  });

  factory UserProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return UserProfile(
      email: data?['email'],
      userName: data?['name'],
      userColor: data?['color'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) 'email': email,
      if (userName != null) 'name': userName,
      if (userColor != null) 'color': userColor,
    };
  }
}

class GroupProfile {
  final String? groupName;
  final String? groupColor;
  String groupId = '';

  GroupProfile({
    this.groupName,
    this.groupColor,
  });

  factory GroupProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return GroupProfile(
      groupName: data?['name'],
      groupColor: data?['color'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (groupName != null) 'name': groupName,
      if (groupColor != null) 'color': groupColor,
    };
  }
}

Future<void> setProfileForPerson(
    {required UserProfile newProfile, required String userId}) async {
  final profileLocation = FirebaseFirestore.instance
      .collection('client_properties')
      .doc(userId)
      .collection('profile')
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
      .collection('client_properties')
      .doc(groupId)
      .collection('profile')
      .doc('profile')
      .withConverter(
        fromFirestore: GroupProfile.fromFirestore,
        toFirestore: (GroupProfile profile, options) => profile.toFirestore(),
      );
  await profileLocation.set(newProfile, SetOptions(merge: true));
  return;
}

Future<UserProfile> getProfileForPerson({required String userId}) async {
  final profileLocation = FirebaseFirestore.instance
      .collection('client_properties')
      .doc(userId)
      .collection('profile')
      .doc('profile')
      .withConverter(
        fromFirestore: UserProfile.fromFirestore,
        toFirestore: (UserProfile profile, options) => profile.toFirestore(),
      );
  final profileSnap = await profileLocation.get();
  UserProfile profile = profileSnap.data() ??
      UserProfile(
          email: 'unknown', userName: 'unknown', userColor: '0xFFFCBF49');
  profile.userId = profileSnap.id;
  return profile;
}

Future<GroupProfile> getProfileForGroup({required String groupId}) async {
  final profileLocation = FirebaseFirestore.instance
      .collection('client_properties')
      .doc(groupId)
      .collection('profile')
      .doc('profile')
      .withConverter(
        fromFirestore: GroupProfile.fromFirestore,
        toFirestore: (GroupProfile profile, options) => profile.toFirestore(),
      );
  final profileSnap = await profileLocation.get();
  GroupProfile profile = profileSnap.data() ??
      GroupProfile(groupName: 'unknown', groupColor: '0xFFFCBF49');
  profile.groupId = profileSnap.id;
  return profile;
}

// Future<String?> getUserId({required String email}) async {
//   final profileLocation = FirebaseFirestore.instance
//       .collectionGroup('profile')
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
    groupList.addAll({groupSnap.id: groupSnap.data()['name'] as String});
  }
  return groupList;
}
