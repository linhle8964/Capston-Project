import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_app/bloc/invite_email/bloc.dart';
import 'package:wedding_app/model/invite_email.dart';
import 'package:wedding_app/repository/invite_email_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import '../mock.dart';
import '../mock_user.dart' as mock_user;

class MockInviteEmailRepository extends Mock implements InviteEmailRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockUserWeddingRepository extends Mock implements UserWeddingRepository {}

void main() {
  final invalidEmailUser = mock_user.MockUser(
    email: "nangld290498@gmail.com",
    emailVerified: true,
  );
  group("Invite Email Bloc", () {
    final String code = "O60ymX";
    MockInviteEmailRepository mockInviteEmailRepository;
    MockUserWeddingRepository mockUserWeddingRepository;
    MockUserRepository mockUserRepository;
    setupFirebaseAuthMocks();
    setUpAll(() async {
      await Firebase.initializeApp();
      mockInviteEmailRepository = MockInviteEmailRepository();
      mockUserWeddingRepository = MockUserWeddingRepository();
      mockUserRepository = MockUserRepository();
    });

    test("initial state is empty", () {
      expect(
          InviteEmailBloc(
                  userWeddingRepository: mockUserWeddingRepository,
                  inviteEmailRepository: mockInviteEmailRepository,
                  userRepository: mockUserRepository)
              .state,
          InviteEmailLoading());
    });

    test('throws AssertionError when userWeddingRepository is null', () {
      expect(
          () => InviteEmailBloc(
              userWeddingRepository: null,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository),
          throwsA(isA<AssertionError>()));
    });

    test('throws AssertionError when inviteEmailRepository is null', () {
      expect(
          () => InviteEmailBloc(
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: null,
              userRepository: mockUserRepository),
          throwsA(isA<AssertionError>()));
    });

    test('throws AssertionError when userRepository is null', () {
      expect(
          () => InviteEmailBloc(
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: null),
          throwsA(isA<AssertionError>()));
    });

    blocTest("demo",
        build: () {
          InviteEmail inviteEmail = new InviteEmail(
              id: "4Yj3S4Mz7cc5jQfZR2iT",
              code: code,
              to: "nangld290498@gmail.com");
          when(mockInviteEmailRepository.getInviteEmailByCode(code))
              .thenAnswer((_) async => inviteEmail);
          when(mockUserRepository.getUser())
              .thenAnswer((_) async => invalidEmailUser);
          return InviteEmailBloc(
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository);
        },
        act: (InviteEmailBloc bloc) async => bloc.add(SubmittedCode(code)),
        expect: [
          InviteEmailProcessing(),
          InviteEmailError(message: "Mã không đúng")
        ]);
  });
}
