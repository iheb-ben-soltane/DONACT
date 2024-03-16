class Association {
  String Id = '';
  String name = '';
  String phone = '';
  String email = '';
  String password = '';
  String profilePicture = '/volunteers/profile.png';

  Association(
    String usermail,
    String username,
    String userphone,
    String profilePic,
  ) {
    this.name = username;
    this.phone = userphone;
    this.email = usermail;
    this.profilePicture = '/volunteers/profile.png';
  }

  Association.empty();

  Association.fromMap(Map<String, dynamic> map) {
    Id = map["Id"] ?? '';
    name = map['name'] ?? '';
    phone = map['phone'] ?? '';
    email = map['email'] ?? '';
    profilePicture = map['profilePicture'] ?? '/volunteers/profile.png';
  }

  Map<String, dynamic> userToMap(Association user) {
    Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = user.Id;
    data['name'] = user.name;
    data['phone'] = user.phone;
    data['email'] = user.email;
    data['profilePicture'] = user.profilePicture;

    return data;
  }

  String userToString(Association user) {
    String data = '{}';
    data += 'Id :' + user.Id + ',';
    data += 'name :' + user.name + ',';
    data += 'phone :' + user.phone + ',';
    data += 'email :' + user.email + ',';
    data += 'profilePicture :' + user.profilePicture + ',';

    return data;
  }
}
