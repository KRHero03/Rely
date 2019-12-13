import 'package:Rely/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  //Authentication Firebase Object
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create User object from FirebaseUser object
  User _getUser(FirebaseUser user){
    return  user == null ? null : User(uid: user.uid); //Function is used to instantiate User object from FirebaseUser instance.
  }

  //When Authentication is Done, Stream is used to notify wrapper.
  Stream<User> get user{
    return _auth.onAuthStateChanged
    .map(_getUser); //Maps FirebaseUser Instance to custom User instance using _getUser function.
                    //It is the same process as Pipelining. The Auth instance provides a FirebaseUser Object
                    //that is passed into _getUser which returns User object.
  }

}