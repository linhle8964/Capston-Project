import 'package:wedding_app/bloc/invite_email/bloc.dart';
import 'package:wedding_app/model/invite_email.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/repository/invite_email_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wedding_app/const/message_const.dart';
import '../mock.dart';
import '../mock_user.dart' as mock_user;
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';

class MockInviteEmailRepository extends Mock implements InviteEmailRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockUserWeddingRepository extends Mock implements UserWeddingRepository {}

void main() {
  final instance = MockFirestoreInstance();
  final String email = "nangld290498@gmail.com";
  final String code = "code";
  final String role = "editor";
  final String weddingId = "weddingId";
  final user = mock_user.MockUser(
    email: email,
    uid: "id",
    emailVerified: true,
  );

  final wrongEmailUser = mock_user.MockUser(
    email: "email",
    uid: "id",
    emailVerified: true,
  );

  final InviteEmail inviteEmail = new InviteEmail(
      id: "4Yj3S4Mz7cc5jQfZR2iT",
      code: code,
      to: email,
      role: role,
      weddingId: weddingId,
      from: email,
      title: "",
      body: "",
      date: DateTime.now());

  final UserWedding userWedding = new UserWedding(email, id: "id");
  group("Invite Email Bloc", () {
    MockInviteEmailRepository mockInviteEmailRepository;
    MockUserWeddingRepository mockUserWeddingRepository;
    MockUserRepository mockUserRepository;
    setupFirebaseAuthMocks();
    setUpAll(() async {
      await Firebase.initializeApp();
      await instance
          .collection("invite_email")
          .add(inviteEmail.toEntity().toDocument());
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

    blocTest("join wedding success",
        build: () {
          when(mockInviteEmailRepository.getInviteEmailByCode(code))
              .thenAnswer((_) async => inviteEmail);
          when(mockUserRepository.getUser()).thenAnswer((_) async => user);
          when(mockUserWeddingRepository.getUserWeddingByEmail(email))
              .thenAnswer((realInvocation) async => userWedding);
          return InviteEmailBloc(
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository);
        },
        act: (InviteEmailBloc bloc) async => bloc.add(SubmittedCode(code)),
        expect: [
          InviteEmailProcessing(),
          InviteEmailSuccess(message: MessageConst.commonSuccess)
        ]);

    blocTest("join wedding emit [invalid] when wrong email",
        build: () {
          when(mockInviteEmailRepository.getInviteEmailByCode(code))
              .thenAnswer((_) async => inviteEmail);
          when(mockUserRepository.getUser()).thenAnswer((_) async => wrongEmailUser);
          when(mockUserWeddingRepository.getUserWeddingByEmail(email))
              .thenAnswer((realInvocation) async => userWedding);
          return InviteEmailBloc(
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository);
        },
        act: (InviteEmailBloc bloc) async => bloc.add(SubmittedCode(code)),
        expect: [
          InviteEmailProcessing(),
          InviteEmailError(message: MessageConst.codeNotFound)
        ]);

    blocTest("join wedding emit [invalid] when wrong email",
        build: () {
          when(mockInviteEmailRepository.getInviteEmailByCode(code))
              .thenAnswer((_) async => null);
          when(mockUserRepository.getUser()).thenAnswer((_) async => user);
          when(mockUserWeddingRepository.getUserWeddingByEmail(email))
              .thenAnswer((realInvocation) async => userWedding);
          return InviteEmailBloc(
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository);
        },
        act: (InviteEmailBloc bloc) async => bloc.add(SubmittedCode(code)),
        expect: [
          InviteEmailProcessing(),
          InviteEmailError(message: MessageConst.codeNotFound)
        ]);

    blocTest("join wedding emit [invalid] when wrong email",
        build: () {
          when(mockInviteEmailRepository.getInviteEmailByCode(code))
              .thenAnswer((_) async => null);
          when(mockUserRepository.getUser()).thenAnswer((_) async => user);
          when(mockUserWeddingRepository.getUserWeddingByEmail(email))
              .thenAnswer((realInvocation) async => userWedding);
          return InviteEmailBloc(
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository);
        },
        act: (InviteEmailBloc bloc) async => bloc.add(SubmittedCode(code)),
        expect: [
          InviteEmailProcessing(),
          InviteEmailError(message: MessageConst.commonError)
        ]);
  });

}
