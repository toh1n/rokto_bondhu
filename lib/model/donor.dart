import 'package:cloud_firestore/cloud_firestore.dart';

class DonorModel {
  String? uid;
  String? displayName;
  String? photoUrl;
  String? phoneNumber;
  String? bloodGroup;
  String? gender;
  String? dateOfBirth;
  String? city;
  String? area;
  String? email;

  DonorModel(
      {this.uid,
      this.email,
      this.displayName,
      this.photoUrl,
      this.city,
      this.area,
      this.bloodGroup,
      this.phoneNumber,
      this.gender,
      this.dateOfBirth});


  factory DonorModel.fromMap(Map<String,dynamic> doc) {

    return DonorModel(
      email: doc['email'],
      displayName: doc['displayName'],
      photoUrl: doc['photoUrl'],
      city: doc['city'],
      area: doc['area'],
      bloodGroup: doc['bloodGroup'],
      phoneNumber: doc['phoneNumber'],
      gender: doc['gender'],
      dateOfBirth: doc['dateOfBirth'],
    );
  }

// send data to server
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'id': uid,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'city': city,
      'area': area,
      'bloodGroup': bloodGroup,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
    };
  }


}
