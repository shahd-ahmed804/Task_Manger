class UserModel {
  static const String collection = 'Users';
  UserModel({this.email, this.name, this.password, this.id});
  String? name;
  String? email;
  String? password;
  String? id;
   UserModel.fromJson(Map<String, dynamic> Json) 
    : this(
      name: Json['name'],
      password: Json['password'],
      email: Json['email'],
      id: Json['id'],
    );
  
  Map<String, dynamic> toJson ()=> {
    'name': name,
    'email': email,
    'password': password,
    'id': id,
  };
}
