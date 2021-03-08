import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/login/bloc.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/repository/user_repository.dart';

import 'authentication.dart';

class MockLoginRepository extends Mock implements FirebaseUserRepository {}

void main() {
  const invalidEmailString = "invalid";
  const invalidPasswordString = "invalid";
  const validEmailString = "linhle8963@gmail.com";
  const validPasswordString = "linhle8964";

  const existEmailString = "linhle8964@gmail.com";
  const notExistEmailString = "linhle8963@gmail.com";
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

    group('submit login,', () {
      blocTest("emit [valid]",
          build: () {
        final user = MockUser();
            when(mockLoginRepository.signInWithCredentials("linhle8964@gmail.com", "linhle8964")).thenAnswer((_) async => user);
            return LoginBloc(userRepository: mockLoginRepository);
          },
          act: (bloc) => bloc.add(LoginWithCredentialsPressed(
              email: "linhle8964@gmail.com", password: "linhle8964")),
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
                message: "Có lỗi xảy ra"),
          ]);
    });
  });
}
