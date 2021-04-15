import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EmailNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

class TooManyRequestException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class FirebaseException implements Exception {}

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
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          user.sendEmailVerification();
        }
        return user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.message);
        throw EmailNotFoundException();
      } else if (e.code == 'wrong-password') {
        print(e.message);
        throw WrongPasswordException();
      } else if (e.code == 'too-many-requests') {
        print(e.message);
        throw TooManyRequestException();
      } else {
        print(e.code);
        throw FirebaseException();
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Có lỗi xảy ra");
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

    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    final User user = userCredential.user;

    if (user != null) {
      if (!user.emailVerified) user.sendEmailVerification();
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
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User user = userCredential.user;

      if (user != null) {
        user.sendEmailVerification();
        return user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else {
        print(e.code);
        throw FirebaseException();
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Có lỗi xảy ra");
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser.emailVerified;
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw EmailNotFoundException();
      }
    } catch (e) {
      print("Error: $e");
      throw Exception(MessageConst.commonError);
    }
  }

  @override
  Future<bool> validateCurrentPassword(String password) async {
    try {
      var firebaseUser = _firebaseAuth.currentUser;

      var authCredentials = EmailAuthProvider.credential(
          email: firebaseUser.email, password: password);

      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);

      return authResult.user != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      }
    }
    return false;
  }

  @override
  Future<void> updatePassword(String password) async {
    //Create an instance of the current user.
    var user = _firebaseAuth.currentUser;

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Successfully changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
}
