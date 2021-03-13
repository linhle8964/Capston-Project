import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/register/bloc.dart';
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
                message: ""),
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
                message: ""),
          ]);
    });

    group(' Password Changed,', () {
      blocTest("emit [invalid] when password is invalid",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) => bloc.add(PasswordChanged(password: invalidPasswordString)),
          wait: const Duration(milliseconds: 500),
          expect: [
            RegisterState(
                isEmailValid: true,
                isPasswordValid: false,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: ""),
          ]);
      blocTest("emit [valid] when password is valid",
          build: () => RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository),
          act: (bloc) => bloc.add(PasswordChanged(password: validPasswordString)),
          wait: const Duration(milliseconds: 500),
          expect: [
            RegisterState(
                isEmailValid: true,
                isPasswordValid: true,
                isSubmitting: false,
                isSuccess: false,
                isFailure: false,
                message: ""),
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
          message: ""),
      expect: [
        RegisterState.loading(),
        RegisterState.failure("Email đã tồn tại")
      ]
      );

      blocTest("emit valid", build: (){
        when(mockUserRepository.signUp(email: validEmailString, password: validPasswordString)).thenAnswer((_) async => user);
        return RegisterBloc(userRepository: mockUserRepository, userWeddingRepository: mockUserWeddingRepository);
      },
          act: (bloc) => bloc.add(Submitted(email: validEmailString, password: validPasswordString)),
          expect: [
            RegisterState.loading(),
            RegisterState.success("Đăng ký thành công")
          ]
      );
    });
  });
}