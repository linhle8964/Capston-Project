import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/register/bloc.dart';
import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import '../mock_user.dart' as mock_user;

class MockUserRepository extends Mock implements FirebaseUserRepository {}
class MockUserWeddingRepository extends Mock implements FirebaseUserWeddingRepository{}

void main(){
  const invalidEmailString = "invalid";
  const invalidPasswordString = "invalid";
  const validEmailString = "linhle8964@gmail.com";
  const validPasswordString = "linhle8964";

  final user = mock_user.MockUser(email: validEmailString, uid: "abc");

  group("Sign up bloc", (){
    MockUserRepository mockUserRepository;
    MockUserWeddingRepository mockUserWeddingRepository;

    setUp((){
      mockUserRepository = MockUserRepository();
      mockUserWeddingRepository = MockUserWeddingRepository();
    });

    test('throws AssertionError when userRepository is null', () {
      expect(() => RegisterBloc(userRepository: null, userWeddingRepository: mockUserWeddingRepository),
          throwsA(isA<AssertionError>()));
    });

    test('throws AssertionError when userWeddingRepository is null', () {
      expect(() => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: null),
          throwsA(isA<AssertionError>()));
    });

    test("initial state is empty", (){
      expect(RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository).state, RegisterState.empty());
    });

    group(' Email Changed,', () {
      blocTest("emit [invalid] when email is invalid",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) => bloc.add(EmailChanged(email: invalidEmailString)),
          wait: const Duration(milliseconds: 300),
          expect: [
            RegisterState(
                isEmailValid: false,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);

      blocTest("emit [invalid] when email is without @ symbol",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) => bloc.add(EmailChanged(email: "testAtgmail.com")),
          wait: const Duration(milliseconds: 300),
          expect: [
            RegisterState(
                isEmailValid: false,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);

      blocTest("emit [invalid] when email has a missing dot in the email address",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) => bloc.add(EmailChanged(email: "test@gmailcom")),
          wait: const Duration(milliseconds: 300),
          expect: [
            RegisterState(
                isEmailValid: false,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);

      blocTest("emit [invalid] when email is invalid",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) => bloc.add(EmailChanged(email: "@gmail")),
          wait: const Duration(milliseconds: 300),
          expect: [
            RegisterState(
                isEmailValid: false,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""
            ),
          ]);

      blocTest("emit [invalid] when email is null",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) => bloc.add(EmailChanged(email: null)),
          wait: const Duration(milliseconds: 300),
          seed: RegisterState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: false,
              isSuccess: false,
              isFailure: false,
              message: "",
              passwordErrorMessage: ""),
          expect: [
            RegisterState(
                isEmailValid: false,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);

      blocTest("emit [valid] when email is valid",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) => bloc.add(EmailChanged(email: validEmailString)),
          wait: const Duration(milliseconds: 500),
          expect: [
            RegisterState(
                isEmailValid: true,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);
    });

    group(' Password Changed,', () {
      blocTest("emit [invalid] when password is null",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) =>
              bloc.add(PasswordChanged(password: null)),
          wait: const Duration(milliseconds: 500),
          expect: [
            RegisterState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);

      blocTest("emit [invalid] when password length is < 8",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) =>
              bloc.add(PasswordChanged(password: "ad")),
          wait: const Duration(milliseconds: 500),
          expect: [
            RegisterState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: MessageConst.passwordLengthMin),
          ]);

      blocTest("emit [invalid] when password length is > 20",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) =>
              bloc.add(PasswordChanged(password: "2000000000000000000000000000000000000000000000000000")),
          wait: const Duration(milliseconds: 500),
          expect: [
            RegisterState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: MessageConst.passwordLengthMax),
          ]);

      blocTest("emit [invalid] when password contain only character",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) =>
              bloc.add(PasswordChanged(password: "asdasddasdasdas")),
          wait: const Duration(milliseconds: 500),
          expect: [
            RegisterState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: MessageConst.passwordAtLeastOneNumber),
          ]);

      blocTest("emit [invalid] when password contain only number",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) =>
              bloc.add(PasswordChanged(password: "1234567890")),
          wait: const Duration(milliseconds: 500),
          expect: [
            RegisterState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: MessageConst.passwordAtLeastOneCharacter),
          ]);

      blocTest("emit [valid] when password is valid",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) =>
              bloc.add(PasswordChanged(password: validPasswordString)),
          wait: const Duration(milliseconds: 500),
          expect: [
            RegisterState(
                isEmailValid: true,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);
    });

    group('Submit button', (){
      blocTest("emit invalid when email already in use", build: (){
        when(mockUserRepository.signUp(email: validEmailString, password: validPasswordString)).thenThrow(EmailAlreadyInUseException());
        return RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository);
      },
      act: (bloc) => bloc.add(Submitted(email: validEmailString, password: validPasswordString)),
      seed: RegisterState(
          isEmailValid: true,
          isPasswordValid: true,
          isSubmitting: true,
          isSuccess: false,
          isFailure: false,
          message: "",
          passwordErrorMessage: ""),
      expect: [
        RegisterState.loading(),
        RegisterState.failure(MessageConst.emailAlreadyRegistered)
      ]
      );

      blocTest("emit valid", build: (){
        when(mockUserRepository.signUp(email: validEmailString, password: validPasswordString)).thenAnswer((_) async => user);
        when(mockUserWeddingRepository.createUserWedding(user)).thenAnswer((_) async => (){});
        return RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository);
      },
          act: (bloc) => bloc.add(Submitted(email: validEmailString, password: validPasswordString)),
          expect: [
            RegisterState.loading(),
            RegisterState.success(MessageConst.registerSuccess)
          ]
      );
    });
  });
}