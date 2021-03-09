import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockUserRepository extends Mock implements FirebaseUserRepository {}
class MockUser extends Mock implements User{}
class MockFirebaseAuth extends Mock implements FirebaseAuth{}
class MockUserWeddingRepository extends Mock
    implements FirebaseUserWeddingRepository {}

void main() {
  MockUserRepository mockUserRepository;
  MockUserWeddingRepository mockUserWeddingRepository;
  MockUser mockUser;
  MockFirebaseAuth mockFirebaseAuth;
  setUpAll(() async{
    mockUserRepository = MockUserRepository();
    mockUserWeddingRepository = MockUserWeddingRepository();
    mockFirebaseAuth = FirebaseAuth.instance;
    mockUser = await mockUserRepository.getUser();
  });

  group("AuthenticationBloc", () {
    test('throws when userRepository is null', () {
      expect(
        () => AuthenticationBloc(
            userRepository: null,
            userWeddingRepository: mockUserWeddingRepository),
        throwsAssertionError,
      );
    });

    test('throws when userWeddingRepository is null', () {
      expect(
        () => AuthenticationBloc(
            userRepository: mockUserRepository, userWeddingRepository: null),
        throwsAssertionError,
      );
    });

    test('initial state is AuthenticationState.Uninitialized', () {
      final authenticationBloc = AuthenticationBloc(
        userRepository: mockUserRepository,
        userWeddingRepository: mockUserWeddingRepository,
      );
      expect(authenticationBloc.state, Uninitialized());
      authenticationBloc.close();
    });

    blocTest("'subscribes to user stream',",
        build: () {
          return AuthenticationBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository);
        },
        act: (bloc) => bloc.add(LoggedIn()),
        expect: [WeddingNull(mockUser),]);

    blocTest("Log out",
        build: () => AuthenticationBloc(
            userRepository: mockUserRepository,
            userWeddingRepository: mockUserWeddingRepository),
        act: (bloc) => bloc.add(LoggedOut()),
        expect: [Unauthenticated()]);
  });
}
