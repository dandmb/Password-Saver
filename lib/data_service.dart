import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:passbox/services/model/data_model.dart';
import 'package:passbox/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();
  final String _auth = FirebaseAuth.instance.currentUser!.uid;

  String _mediaUrl = '';

  Future<Data> addData(String siteName,String emailAddress,String passWord) async {
    var ref = _firestore.collection("Data");
    var refUid=ref.doc(_auth).collection("items").doc();


    //_mediaUrl = await _storageService.uploadMedia(File(pickedFile.path));

    //var documentRef = await ref.add({'siteName': siteName,'emailAddress':emailAddress,'passWord':passWord, 'image': _mediaUrl});
    var documentRef = await refUid.set({'siteName': siteName,'emailAddress':emailAddress,'passWord':passWord, 'image': _mediaUrl});

    return Data(id: refUid.id, image: _mediaUrl,siteName: siteName,emailAddress:emailAddress, passWord:passWord);
  }

  Stream<QuerySnapshot> getData() {
    var ref = _firestore.collection("Data").doc(_auth).collection("items").snapshots();

    return ref;
  }
  Stream<QuerySnapshot> getDatabyId() {
    var ref = _firestore.collection("Data").snapshots();

    return ref;
  }
  Future<void> removeData(String docId) {
    var ref = _firestore.collection("Data").doc(docId).delete();

    return ref;
  }
}
