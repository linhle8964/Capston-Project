import 'package:wedding_app/bloc/invite_email/bloc.dart';
import 'package:wedding_app/model/invite_email.dart';
import 'package:wedding_app/repository/invite_email_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import '../mock.dart';

class MockInviteEmailRepository extends Mock implements InviteEmailRepository {}

class MockUserWeddingRepository extends Mock implements UserWeddingRepository {}

void main() {
  group("Invite Email Bloc", () {
    final String code = "O60ymX";
    MockInviteEmailRepository mockInviteEmailRepository;
    MockUserWeddingRepository mockUserWeddingRepository;
    setupFirebaseAuthMocks();
    setUpAll(() async {
      await Firebase.initializeApp();
      mockInviteEmailRepository = MockInviteEmailRepository();
      mockUserWeddingRepository = MockUserWeddingRepository();
    });

    blocTest("demo",
        build: () {
          InviteEmail inviteEmail = new InviteEmail(
              id: "4Yj3S4Mz7cc5jQfZR2iT",
              code: code,
              to: "nangld290498@gmail.comh");
          when(mockInviteEmailRepository.getInviteEmailByCode("O60ymX"))
              .thenAnswer((_) async => inviteEmail);
          return InviteEmailBloc(
              inviteEmailRepository: mockInviteEmailRepository,
              userWeddingRepository: mockUserWeddingRepository);
        },
        act: (InviteEmailBloc bloc) async => bloc.add(SubmittedCode(code)),
        expect: [
          InviteEmailProcessing(),
          InviteEmailError(message: "Có lỗi xảy ra")
        ]);
  });
}
