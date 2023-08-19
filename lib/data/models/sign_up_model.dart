class SignUpModel {
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
  String? lastDonated;


  SignUpModel(
      {this.uid,
        this.email,
        this.displayName,
        this.photoUrl,
        this.city,
        this.area,
        this.bloodGroup,
        this.phoneNumber,
        this.gender,
        this.dateOfBirth,
        this.lastDonated,
      });


  factory SignUpModel.fromMap(Map<String,dynamic> doc) {

    return SignUpModel(
      email: doc['email'],
      displayName: doc['displayName'],
      photoUrl: doc['photoUrl'],
      city: doc['city'],
      area: doc['area'],
      bloodGroup: doc['bloodGroup'],
      phoneNumber: doc['phoneNumber'],
      gender: doc['gender'],
      dateOfBirth: doc['dateOfBirth'],
      lastDonated: doc['lastDonated'],

    );
  }

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
      'lastDonated' : lastDonated,
    };
  }


}