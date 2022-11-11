import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/providers/firebase_provider.dart';
import 'package:reddit/core/type_defs.dart';
import 'package:reddit/failure.dart';
import 'package:reddit/models/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;

  const PostRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  FutureVoid addPost(PostModel post) async {
    try {
      return right(_posts.doc(post.id).set(post.toJson()));
    } on FirebaseException catch (e) {
      throw(e.message!);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
}
