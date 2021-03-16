import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {
  final bool _isAnonymous;
  final String _uid;
  final String _email;
  final String _displayName;
  final String _phoneNumber;
  final String _photoURL;
  final String _refreshToken;
  final bool _emailVerified;

  MockUser({
    bool isAnonymous = false,
    String uid = 'some_random_id',
    String email,
    String displayName,
    String phoneNumber,
    String photoURL,
    String refreshToken,
    bool emailVerified,
  })  : _isAnonymous = isAnonymous,
        _uid = uid,
        _email = email,
        _displayName = displayName,
        _phoneNumber = phoneNumber,
        _photoURL = photoURL,
        _refreshToken = refreshToken,
        _emailVerified = emailVerified;

  @override
  bool get isAnonymous => _isAnonymous;

  @override
  String get uid => _uid;

  @override
  String get email => _email;

  @override
  String get displayName => _displayName;

  @override
  String get phoneNumber => _phoneNumber;

  @override
  String get photoURL => _photoURL;

  @override
  String get refreshToken => _refreshToken;

  @override
  bool get emailVerified => _emailVerified;

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async {
    return Future.value('fake_token');
  }

  @override
  bool operator ==(o) =>
      o is User &&
          _isAnonymous == o.isAnonymous &&
          _uid == o.uid &&
          _email == o.email &&
          _displayName == o.displayName &&
          _phoneNumber == o.phoneNumber &&
          _photoURL == o.photoURL &&
          _refreshToken == o.refreshToken &&
          _emailVerified == o.emailVerified;

  @override
  int get hashCode =>
      _isAnonymous.hashCode ^
      _uid.hashCode ^
      _email.hashCode ^
      _displayName.hashCode ^
      _phoneNumber.hashCode ^
      _photoURL.hashCode ^
      _refreshToken.hashCode ^
      _emailVerified.hashCode;
}
