class UserModel {
  String uid;
  String name;
  String email;
  String password;
  String image;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.image,
  });

  factory UserModel.fromMap({required Map<String, dynamic> data}) => UserModel(
        uid: data['uid'],
        name: data['name'],
        email: data['email'],
        password: data['password'],
        image: data['image'],
      );

  Map<String, dynamic> get toMap => {
        'uid': uid,
        'name': name,
        'email': email,
        'password': password,
        'image': image,
      };
}
