import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/wedding_firebase_repository.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/model/wedding.dart';
import '../mock_user.dart' as mock_user;

class MockUserRepository extends Mock implements FirebaseUserRepository {}

class MockWeddingRepository extends Mock implements FirebaseWeddingRepository {}

class MockUserWeddingRepository extends Mock
    implements FirebaseUserWeddingRepository {}

void main() {
  MockUserRepository mockUserRepository;
  MockUserWeddingRepository mockUserWeddingRepository;
  MockWeddingRepository mockWeddingRepository;

  final user = mock_user.MockUser(
      email: "linhle8964@gmail.com", emailVerified: true, uid: "userId");

  final UserWedding invalidUserWedding =
      UserWedding("linhle8964@gmail.com", weddingId: null);
  final UserWedding validUserWedding = UserWedding("linhle8964@gmail.com",
      weddingId: "weddingId",
      id: "id",
      role: "editor",
      joinDate: DateTime.now(),
      userId: "userId");

  final Wedding wedding = Wedding("brideName", "groomName", DateTime.now(), "image", "address", id: "id", budget: 100000, dateCreated: DateTime.now(), modifiedDate: DateTime.now());
  setUpAll(() async {
    mockUserRepository = MockUserRepository();
    mockUserWeddingRepository = MockUserWeddingRepository();
    mockWeddingRepository = MockWeddingRepository();
  });

  group("AuthenticationBloc", () {
    test('throws when userRepository is null', () {
      expect(
        () => AuthenticationBloc(
            userRepository: null,
            userWeddingRepository: mockUserWeddingRepository,
            weddingRepository: mockWeddingRepository),
        throwsAssertionError,
      );
    });

    test('throws when userWeddingRepository is null', () {
      expect(
        () => AuthenticationBloc(
            weddingRepository: mockWeddingRepository,
            userRepository: mockUserRepository,
            userWeddingRepository: null),
        throwsAssertionError,
      );
    });

    test('throws when weddingRepository is null', () {
      expect(
        () => AuthenticationBloc(
            weddingRepository: null,
            userRepository: mockUserRepository,
            userWeddingRepository: mockUserWeddingRepository),
        throwsAssertionError,
      );
    });

    test('initial state is AuthenticationState.Uninitialized', () {
      final authenticationBloc = AuthenticationBloc(
        weddingRepository: mockWeddingRepository,
        userRepository: mockUserRepository,
        userWeddingRepository: mockUserWeddingRepository,
      );
      expect(authenticationBloc.state, Uninitialized());
      authenticationBloc.close();
    });

    blocTest("when user don't have a wedding",
        build: () {
          when(mockUserRepository.getUser()).thenAnswer((_) async => user);
          when(mockUserWeddingRepository.getUserWeddingByUser(user))
              .thenAnswer((_) async => invalidUserWedding);
          return AuthenticationBloc(
              userRepository: mockUserRepository,
              weddingRepository: mockWeddingRepository,
              userWeddingRepository: mockUserWeddingRepository);
        },
        act: (bloc) => bloc.add(LoggedIn()),
        expect: [
          WeddingNull(user),
        ]);

    blocTest("when user have a wedding",
        build: () {
          when(mockUserRepository.getUser()).thenAnswer((_) async => user);
          when(mockUserWeddingRepository.getUserWeddingByUser(user))
              .thenAnswer((_) async => validUserWedding);
          when(mockWeddingRepository.getWeddingById(validUserWedding.weddingId)).thenAnswer((_) async=> wedding);
          return AuthenticationBloc(
              userRepository: mockUserRepository,
              weddingRepository: mockWeddingRepository,
              userWeddingRepository: mockUserWeddingRepository);
        },
        act: (bloc) => bloc.add(LoggedIn()),
        expect: [
          Authenticated(user),
        ]);

    blocTest("Log out",
        build: () => AuthenticationBloc(
            weddingRepository: mockWeddingRepository,
            userRepository: mockUserRepository,
            userWeddingRepository: mockUserWeddingRepository),
        act: (bloc) => bloc.add(LoggedOut()),
        expect: [Unauthenticated()]);
  });
}
