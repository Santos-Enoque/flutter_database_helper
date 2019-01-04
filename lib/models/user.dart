class User {
  String _username;
  String _password;
  int _id;

  User(this._username, this._password);

//now we map the values using a constructor
//  this will convert objects of map or list type into User type
  User.map(dynamic obj) {
    this._password = obj["password"];
    this._username = obj["username"];
    this._id = obj["id"];
  }

//now we create getters to access our private variables
  String get username => _username;

  String get password => _password;

  int get id => _id;

//  now we are going to convert everything to a map, with the key as a string and the value dynamic
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;

//  if the id is set
    if (id != null) {
      map["id"] = _id;
    }

    return map;
  }

//  now lets set the values from map into our private variables
User.fromMap(Map<String, dynamic> map){
    this._username = map["username"];
    this._password = map["password"];
    this._id = map["id"];


}
}
