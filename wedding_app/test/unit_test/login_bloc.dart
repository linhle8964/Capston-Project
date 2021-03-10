import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/login/bloc.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import '../mock_user.dart' as mock_user;
class MockLoginRepository extends Mock implements FirebaseUserRepository {}

void main() {
  const invalidEmailString = "invalid";
  const invalidPasswordString = "invalid";
  const validEmailString = "linhle8964@gmail.com";
  const validPasswordString = "linhle8964";

  final notVerifiedUser = mock_user.MockUser(
    email: validEmailString,
    emailVerified: false,
  );

  final invalidEmailUser = mock_user.MockUser(
    email: "linhle8963@gmail.com",
    emailVerified: true,
  );
  group("LoginBloc", () {
    MockLoginRepository mockLoginRepository;
    LoginBloc loginBloc;
    setUp(() {
      mockLoginRepository = MockLoginRepository();
      loginBloc = LoginBloc(userRepository: mockLoginRepository);
    });

    test('throws AssertionError when authenticationRepository is null', () {
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
                message: ""),
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
                message: ""),
          ]);
    });

    group(' Password Changed,', () {
      blocTest("emit [invalid] when password is invalid",
          build: () => loginBloc,
          act: (bloc) => bloc.add(PasswordChanged(password: invalidPasswordString)),
          wait: const Duration(milliseconds: 500),
          expect: [
            LoginState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: ""),
          ]);
      blocTest("emit [valid] when password is valid",
          build: () => loginBloc,
          act: (bloc) => bloc.add(PasswordChanged(password: validPasswordString)),
          wait: const Duration(milliseconds: 500),
          expect: [
            LoginState(
                isEmailValid: true,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: ""),
          ]);
    });

    group('submit login,', () {
      blocTest("emit [invalid] when email isn't verified",
          build: () {
            when(mockLoginRepository.signInWithCredentials(validEmailString, validPasswordString)).thenAnswer((_) async => notVerifiedUser);
            return LoginBloc(userRepository: mockLoginRepository);
          },
          act: (bloc) => bloc.add(LoginWithCredentialsPressed(
              email: validEmailString, password: validPasswordString)),
          seed: LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: true,
              isSuccess: false,
              isFailure: false,
              message: ""),
          expect: [
            LoginState(
                isEmailValid: true,
                isPasswordValid: true,
                isSubmitting: true,
                isSuccess: false,
                isFailure: false,
                message: "Đang xử lý dữ liệu"),
            LoginState(
                isEmailValid: true,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: true,
                message: "Bạn chưa xác nhận email"),
          ]);
    });

    blocTest("emit [invalid] when wrong password",
        build: () {
          when(mockLoginRepository.signInWithCredentials(validEmailString, validPasswordString)).thenThrow(EmailNotFoundException());
          return LoginBloc(userRepository: mockLoginRepository);
        },
        act: (bloc) => bloc.add(LoginWithCredentialsPressed(
            email: validEmailString, password: validPasswordString)),
        seed: LoginState(
            isEmailValid: true,
            isPasswordValid: true,
            isSubmitting: true,
            isSuccess: false,
            isFailure: false,
            message: ""),
        expect: [
          LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: true,
              isSuccess: false,
              isFailure: false,
              message: "Đang xử lý dữ liệu"),
          LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: false,
              isSuccess: false,
              isFailure: true,
              message: "Tài khoản không tồn tại"),
        ]);

    blocTest("emit [invalid] when wrong password",
        build: () {
          when(mockLoginRepository.signInWithCredentials(validEmailString, validPasswordString)).thenThrow(WrongPasswordException());
          return LoginBloc(userRepository: mockLoginRepository);
        },
        act: (bloc) => bloc.add(LoginWithCredentialsPressed(
            email: validEmailString, password: validPasswordString)),
        seed: LoginState(
            isEmailValid: true,
            isPasswordValid: true,
            isSubmitting: true,
            isSuccess: false,
            isFailure: false,
            message: ""),
        expect: [
          LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: true,
              isSuccess: false,
              isFailure: false,
              message: "Đang xử lý dữ liệu"),
          LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: false,
              isSuccess: false,
              isFailure: true,
              message: "Sai mật khẩu"),
        ]);

    blocTest("emit [invalid] when too many request",
        build: () {
          when(mockLoginRepository.signInWithCredentials(validEmailString, validPasswordString)).thenThrow(TooManyRequestException());
          return LoginBloc(userRepository: mockLoginRepository);
        },
        act: (bloc) => bloc.add(LoginWithCredentialsPressed(
            email: validEmailString, password: validPasswordString)),
        seed: LoginState(
            isEmailValid: true,
            isPasswordValid: true,
            isSubmitting: true,
            isSuccess: false,
            isFailure: false,
            message: ""),
        expect: [
          LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: true,
              isSuccess: false,
              isFailure: false,
              message: "Đang xử lý dữ liệu"),
          LoginState(
              isEmailValid: true,
              isPasswordValid: true,
              isSubmitting: false,
              isSuccess: false,
              isFailure: true,
              message: "Bạn đã đăng nhập quá nhiều lần. Hãy thử lại trong giây lát"),
        ]);
  });
}
