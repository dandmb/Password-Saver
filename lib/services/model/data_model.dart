import 'package:cloud_firestore/cloud_firestore.dart';

class Data{

  String id;
  String image;
  String siteName;
  String emailAddress;
  String passWord;

  Data({
    required this.id,
    required this.image,
    required this.siteName,
    required this.emailAddress,
    required this.passWord,
  });

  factory Data.fromSnapshot(DocumentSnapshot snapshot) {
    return Data(
      id: snapshot.id,
      image: snapshot["image"],
      siteName: snapshot["siteName"],
      emailAddress: snapshot["emailAddress"],
      passWord: snapshot["passWord"],
    );
  }


}