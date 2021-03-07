import 'package:wedding_app/bloc/invite_email/bloc.dart';
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
    MockInviteEmailRepository mockInviteEmailRepository;
    MockUserWeddingRepository mockUserWeddingRepository;
    InviteEmailBloc inviteEmailBloc;
    setupFirebaseAuthMocks();
    setUpAll(() async {
      await Firebase.initializeApp();
      mockInviteEmailRepository = MockInviteEmailRepository();
      mockUserWeddingRepository = MockUserWeddingRepository();
      inviteEmailBloc = InviteEmailBloc(
          inviteEmailRepository: mockInviteEmailRepository,
          userWeddingRepository: mockUserWeddingRepository);
    });

    blocTest("demo",
        build: () => inviteEmailBloc,
        act: (InviteEmailBloc bloc) async => bloc.add(SubmittedCode("O60ymX")),
        expect: [
          InviteEmailProcessing(),
          InviteEmailError(message: "Có lỗi xảy ra")
        ]);
  });
}
