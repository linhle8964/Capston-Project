import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/validate_wedding/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/wedding_firebase_repository.dart';
import 'package:wedding_app/model/wedding.dart';
import '../mock_user.dart' as mock_user;

class MockWeddingRepository extends Mock implements FirebaseWeddingRepository{}
class MockUserWeddingRepository extends Mock implements FirebaseUserWeddingRepository{}
class MockFirebaseAuth extends Mock implements FirebaseAuth{}

void main(){
  const emptyString = "";
  const invalidName = "linh1";
  const validName = "linh";

  final Wedding wedding = new Wedding(validName, validName, DateTime.now(), "default", "address");
  final user = mock_user.MockUser(uid: "uid", email: "linhle8964@gmail.com", );
  group("valid wedding field", (){
    ValidateWeddingBloc validateWeddingBloc;

    setUp((){
      validateWeddingBloc = ValidateWeddingBloc();
    });
    test("initial state is empty", (){
      expect(ValidateWeddingBloc().state, ValidateWeddingState.empty());
    });

    group("Name Changed", (){
      blocTest("emit [invalid] when name is empty",
          build: () => ValidateWeddingBloc(),
      act: (bloc) => bloc.add(GroomNameChanged(groomName: emptyString)),
      wait: const Duration(milliseconds: 300),
      seed: ValidateWeddingState.empty(),
      expect: [
       ValidateWeddingState(isGroomNameValid: false, isBrideNameValid: true, isAddressValid: true)
      ]);

      blocTest("emit [invalid] when name contain number or symbol",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(GroomNameChanged(groomName: invalidName)),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(isGroomNameValid: false, isBrideNameValid: true, isAddressValid: true)
          ]);

      blocTest("emit [invalid] when address is empty",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(AddressChanged(address: emptyString)),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(isGroomNameValid: true, isBrideNameValid: true, isAddressValid: false)
          ]);
    });
  });

  group("crud wedding",(){
    MockWeddingRepository mockWeddingRepository;
    MockUserWeddingRepository mockUserWeddingRepository;
    MockFirebaseAuth mockFirebaseAuth;
    setUp((){
      mockWeddingRepository = MockWeddingRepository();
      mockUserWeddingRepository = MockUserWeddingRepository();
      mockFirebaseAuth = MockFirebaseAuth();
    });

    test('throws AssertionError when weddingRepository is null', () {
      expect(() => WeddingBloc(weddingRepository: null),
          throwsA(isA<AssertionError>()));
    });

    test('throws AssertionError when userWeddingRepository is null', () {
      expect(() => WeddingBloc(userWeddingRepository: null),
          throwsA(isA<AssertionError>()));
    });

    blocTest("create wedding", build: () {
      when(mockFirebaseAuth.currentUser).thenAnswer((_) => user);
      return WeddingBloc(weddingRepository: mockWeddingRepository, userWeddingRepository: mockUserWeddingRepository);
    },
    act: (bloc) => bloc.add(CreateWedding(wedding)),
    expect: [
      Loading("Đang xử lý dữ liệu"),
    //  Success("Tạo thành công")
    ]);
  });
}