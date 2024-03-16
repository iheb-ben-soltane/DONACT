import 'package:cloud_firestore/cloud_firestore.dart';

class Volunteer {
  String Id = '';
  String name = '';
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

Future<void> main() async {
  // Initialize Firebase Firestore
  print('trying to add volenteers ');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  print('trying to add volenteers ');
  // Create instances of Volunteer
  Volunteer volunteer1 = Volunteer(
    'john@example.com',
    'John',
    'Doe',
    '1990-01-01',
    '1234567890',
    'City, Country',
    'profile_image_url1',
  );

  Volunteer volunteer2 = Volunteer(
    'jane@example.com',
    'Jane',
    'Doe',
    '1995-02-15',
    '9876543210',
    'Another City, Country',
    'profile_image_url2',
  );

  Volunteer volunteer3 = Volunteer(
    'bob@example.com',
    'Bob',
    'Smith',
    '1985-08-20',
    '5555555555',
    'Yet Another City, Country',
    'profile_image_url3',
  );

  Volunteer volunteer4 = Volunteer(
    'alice@example.com',
    'Alice',
    'Johnson',
    '1980-12-05',
    '7777777777',
    'One More City, Country',
    'profile_image_url4',
  );

  Volunteer volunteer5 = Volunteer(
    'charlie@example.com',
    'Charlie',
    'Brown',
    '1975-04-10',
    '9999999999',
    'Final City, Country',
    'profile_image_url5',
  );

  // List of volunteers
  List<Volunteer> volunteers = [
    volunteer1,
    volunteer2,
    volunteer3,
    volunteer4,
    volunteer5,
  ];

  // Add volunteers to Firebase Firestore
  for (Volunteer volunteer in volunteers) {
    try {
      await firestore
          .collection('volunteers')
          .add(volunteer.userToMap(volunteer));
      print('Volunteer added successfully: ${volunteer.name}');
    } catch (e) {
      print('Error adding volunteer ${volunteer.name}: $e');
    }
  }
}
