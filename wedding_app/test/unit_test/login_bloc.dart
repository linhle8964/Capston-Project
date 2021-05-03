import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/login/bloc.dart';
import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import '../mock_user.dart' as mock_user;

class MockUserRepository extends Mock implements FirebaseUserRepository {}

void main() {
  const invalidEmailString = "invalid";
  const passwordLengthShorter = "inv";
  const passwordLengthGreater = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
  const validEmailString = "linhle8964@gmail.com";
  const validPasswordString = "linhle8964";

  final notVerifiedUser = mock_user.MockUser(
    email: validEmailString,
    emailVerified: false,
  );

  final verifiedUser = mock_user.MockUser(
    email: validEmailString,
    emailVerified: true,
  );

  group("LoginBloc", () {
    MockUserRepository mockUserRepository;
    // ignore: close_sinks
    LoginBloc loginBloc;
    setUp(() {
      mockUserRepository = MockUserRepository();
      loginBloc = LoginBloc(userRepository: mockUserRepository);
    });

    test('throws AssertionError when userRepository is null', () {
      expect(() => LoginBloc(userRepository: null),
          throwsA(isA<AssertionError>()));
    });

    test('initial state is correct', () {
      expect(loginBloc.state, LoginState.empty());
    });

    group(' Email Changed,', () {
      blocTest("emit [invalid] when email is invalid",
          build: () => loginBloc,
          act: (bloc) => bloc.add(EmailChanged(email: invalidEmailString)),
          wait: const Duration(milliseconds: 300),
          expect: [
            LoginState(
                isEmailValid: false,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);

      blocTest("emit [invalid] when email is without @ symbol",
          build: () => loginBloc,
          act: (bloc) => bloc.add(EmailChanged(email: "testAtgmail.com")),
          wait: const Duration(milliseconds: 300),
          expect: [
            LoginState(
                isEmailValid: false,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);

      blocTest("emit [invalid] when email has a missing dot in the email address",
          build: () => loginBloc,
          act: (bloc) => bloc.add(EmailChanged(email: "test@gmailcom")),
          wait: const Duration(milliseconds: 300),
          expect: [
            LoginState(
                isEmailValid: false,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);

      blocTest("emit [invalid] when email is invalid",
          build: () => loginBloc,
          act: (bloc) => bloc.add(EmailChanged(email: "@gmail")),
          wait: const Duration(milliseconds: 300),
          expect: [
            LoginState(
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
          build: () => loginBloc,
          act: (bloc) => bloc.add(EmailChanged(email: null)),
          wait: const Duration(milliseconds: 300),
          seed: LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: false,
              isSuccess: false,
              isFailure: false,
              message: "",
              passwordErrorMessage: ""),
          expect: [
            LoginState(
                isEmailValid: false,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: null),
          ]);

      blocTest("emit [valid] when email is valid",
          build: () => loginBloc,
          act: (bloc) => bloc.add(EmailChanged(email: validEmailString)),
          wait: const Duration(milliseconds: 500),
          expect: [
            LoginState(
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
          build: () => loginBloc,
          act: (bloc) =>
              bloc.add(PasswordChanged(password: null)),
          wait: const Duration(milliseconds: 500),
          expect: [
            LoginState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);

      blocTest("emit [invalid] when password length is < 8",
          build: () => loginBloc,
          act: (bloc) =>
              bloc.add(PasswordChanged(password: passwordLengthShorter)),
          wait: const Duration(milliseconds: 500),
          expect: [
            LoginState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: MessageConst.passwordLengthMin),
          ]);

      blocTest("emit [invalid] when password length is > 20",
          build: () => loginBloc,
          act: (bloc) =>
              bloc.add(PasswordChanged(password: passwordLengthGreater)),
          wait: const Duration(milliseconds: 500),
          expect: [
            LoginState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: MessageConst.passwordLengthMax),
          ]);

      blocTest("emit [invalid] when password contain only character",
          build: () => loginBloc,
          act: (bloc) =>
              bloc.add(PasswordChanged(password: "asdasddasdasdas")),
          wait: const Duration(milliseconds: 500),
          expect: [
            LoginState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: MessageConst.passwordAtLeastOneNumber),
          ]);

      blocTest("emit [invalid] when password contain only number",
          build: () => loginBloc,
          act: (bloc) =>
              bloc.add(PasswordChanged(password: "1234567890")),
          wait: const Duration(milliseconds: 500),
          expect: [
            LoginState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: MessageConst.passwordAtLeastOneCharacter),
          ]);

      blocTest("emit [valid] when password is valid",
          build: () => loginBloc,
          act: (bloc) =>
              bloc.add(PasswordChanged(password: validPasswordString)),
          wait: const Duration(milliseconds: 500),
          expect: [
            LoginState(
                isEmailValid: true,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: "",
                passwordErrorMessage: ""),
          ]);
    });

    group('submit login,', () {
      blocTest("emit [invalid] when email isn't verified",
          build: () {
            when(mockUserRepository.signInWithCredentials(
                    validEmailString, validPasswordString))
                .thenAnswer((_) async => notVerifiedUser);
            return LoginBloc(userRepository: mockUserRepository);
          },
          act: (bloc) => bloc.add(LoginWithCredentialsPressed(
              email: validEmailString, password: validPasswordString)),
          seed: LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: true,
              isSuccess: false,
              isFailure: false,
              message: "",
              passwordErrorMessage: ""),
          expect: [
            LoginState.loading(),
            LoginState.failure(message: MessageConst.emailNotVerified)
          ]);

      blocTest("emit [invalid] when email not found",
          build: () {
            when(mockUserRepository.signInWithCredentials(
                    validEmailString, validPasswordString))
                .thenThrow(EmailNotFoundException());
            return LoginBloc(userRepository: mockUserRepository);
          },
          act: (bloc) => bloc.add(LoginWithCredentialsPressed(
              email: validEmailString, password: validPasswordString)),
          seed: LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: true,
              isSuccess: false,
              isFailure: false,
              message: "",
              passwordErrorMessage: ""),
          expect: [
            LoginState.loading(),
            LoginState.failure(message: MessageConst.emailNotFoundError)
          ]);

      blocTest("emit [invalid] when wrong password",
          build: () {
            when(mockUserRepository.signInWithCredentials(
                    validEmailString, validPasswordString))
                .thenThrow(WrongPasswordException());
            return LoginBloc(userRepository: mockUserRepository);
          },
          act: (bloc) => bloc.add(LoginWithCredentialsPressed(
              email: validEmailString, password: validPasswordString)),
          seed: LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: true,
              isSuccess: false,
              isFailure: false,
              message: "",
              passwordErrorMessage: ""),
          expect: [
            LoginState.loading(),
            LoginState.failure(message: MessageConst.wrongPasswordError),
          ]);

      blocTest("emit [invalid] when too many request",
          build: () {
            when(mockUserRepository.signInWithCredentials(
                    validEmailString, validPasswordString))
                .thenThrow(TooManyRequestException());
            return LoginBloc(userRepository: mockUserRepository);
          },
          act: (bloc) => bloc.add(LoginWithCredentialsPressed(
              email: validEmailString, password: validPasswordString)),
          seed: LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: true,
              isSuccess: false,
              isFailure: false,
              message: "",
              passwordErrorMessage: ""),
          expect: [
            LoginState.loading(),
            LoginState.failure(message: MessageConst.tooManyRequestError),
          ]);

      blocTest("emit [valid] when login success",
          build: () {
            when(mockUserRepository.signInWithCredentials(
                validEmailString, validPasswordString))
                .thenAnswer((_) async=> verifiedUser);
            return LoginBloc(userRepository: mockUserRepository);
          },
          act: (bloc) => bloc.add(LoginWithCredentialsPressed(
              email: validEmailString, password: validPasswordString)),
          seed: LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: true,
              isSuccess: false,
              isFailure: false,
              message: "",
              passwordErrorMessage: ""),
          expect: [
            LoginState.loading(),
            LoginState.success(),
          ]);
    });
  });
}
