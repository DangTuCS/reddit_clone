import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/providers/firebase_provider.dart';
import 'package:reddit/models/user_model.dart';

import '../../../core/type_defs.dart';
import '../../../failure.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepository {
  final FirebaseFirestore _firestore;

  const UserProfileRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;


  FutureVoid editUser(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }


  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}