import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donact/models/association.dart';

class UserServices {
  final CollectionReference usersColl =
      FirebaseFirestore.instance.collection("Association");

  Future<Association> getUserInfo(String id) async {
    return await usersColl.doc(id).get().then(
        (value) => Association.fromMap(value.data() as Map<String, dynamic>));
  }

  Future addUsers(Association association) async {
    return await usersColl.doc(association.Id).set({
      // Accessing Id through the instance:
      'Id': association.Id,
      'name': association.name,
      'phone': association.phone,
      'email': association.email,
    });
  }

  Future updateUser(Association association) async {
    try {
      await usersColl
          .doc(association.Id)
          .set(Association.empty().userToMap(association))
          .whenComplete(() => print("user is updated !"));
      return association;
    } on Exception catch (_, e) {
      print(e);
    }
    return null;
  }
}
