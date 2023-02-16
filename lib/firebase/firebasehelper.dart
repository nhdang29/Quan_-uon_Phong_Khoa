import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper{
  FirebaseHelper();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference getCollection(String collection) => firestore.collection(collection);

}