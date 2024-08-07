class RegistrationData {
  String email;
  String password;
  String firstName;
  String lastName;
  String dateOfBirth;
  String nationalIDNumber;
  String address;
  String wilaya;
  String commune;
  String phoneNumber;
  String occupation;
  String employerName;
  String workAddress;
  String educationLevel;
  String institutionAttended;
  String degreeEarned;
  String accessibilityNeeds;
  List<String> photos;

  RegistrationData({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.nationalIDNumber,
    required this.address,
    required this.wilaya,
    required this.commune,
    required this.phoneNumber,
    required this.occupation,
    required this.employerName,
    required this.workAddress,
    required this.educationLevel,
    required this.institutionAttended,
    required this.degreeEarned,
    required this.accessibilityNeeds,
    required this.photos,
  });

  // Method to convert RegistrationData to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': {
        '\$date': {'\$numberLong': dateOfBirth}
      },
      'nationalIDNumber': nationalIDNumber,
      'address': address,
      'wilaya': wilaya,
      'commune': commune,
      'phoneNumber': phoneNumber,
      'occupation': occupation,
      'employerName': employerName,
      'workAddress': workAddress,
      'educationLevel': educationLevel,
      'institutionAttended': institutionAttended,
      'degreeEarned': degreeEarned,
      'accessibilityNeeds': accessibilityNeeds,
      'photos': photos,
    };
  }
}
