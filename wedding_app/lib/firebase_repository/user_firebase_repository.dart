import 'package:wedding_app/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseUserRepository extends UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseUserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();
  @override
  Future<void> authenticate() {
    throw UnimplementedError();
  }

  @override
  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<bool> isAuthenticated() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  @override
  Future<User> signInWithCredentials(String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((onError) => {print('[Firebase Log In Error] : $onError')});

    final User user = userCredential.user;

    if (user != null) {
      return user;
    }
    return null;
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential = await _firebaseAuth
        .signInWithCredential(credential)
        .catchError(
            (onError) => {print('[Firebase Google Sign Up Error] : $onError')});

    final User user = userCredential.user;

    if (user != null) {
      return user;
    }

    return null;
  }

  @override
  Future<void> signOut() {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  @override
  Future<User> signUp({String email, String password}) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError(
            (onError) => {print('[Firebase Sign Up Error] : $onError')});

    final User user = userCredential.user;

    if (user != null) {
      return user;
    }
    return null;
  }
}
