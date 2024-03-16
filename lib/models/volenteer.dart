class Volunteer {
  String Id = '';
  String name = ' ';
  String lastName = '';
  String birthDate = '';
  String phone = '';
  String email = '';
  String password = '';
  String profileImage = '';
  String location = '';

  Volunteer(
    String usermail,
    String username,
    String userlastname,
    String userBirthDate,
    String userphone,
    String userLocation,
    String userProfileImage,
  ) {
    this.name = username;
    this.lastName = userlastname;
    this.birthDate = userBirthDate;
    this.phone = userphone;
    this.email = usermail;
    this.location = userLocation;
    this.profileImage = userProfileImage;
  }

  Volunteer.empty();

  Volunteer.fromMap(Map<String, dynamic> map) {
    Id = map["Id"] ?? '';
    name = map['name'] ?? '';
    lastName = map['lastName'] ?? '';
    birthDate = map['birthDate'] ?? '';
    phone = map['phone'] ?? '';
    email = map['email'] ?? '';
    location = map['location'] ?? '';
    profileImage = map['profileImage'] ?? '';
  }

  Map<String, dynamic> userToMap(Volunteer user) {
    Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = user.Id;
    data['name'] = user.name;
    data['lastName'] = user.lastName;
    data['birthDate'] = user.birthDate;
    data['phone'] = user.phone;
    data['email'] = user.email;
    data['location'] = user.location;
    data['profileImage'] = user.profileImage;

    return data;
  }
}
