import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/validate_wedding/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/firebase_repository/invite_email_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/wedding_firebase_repository.dart';
import 'package:wedding_app/model/wedding.dart';
import '../mock_user.dart' as mock_user;

class MockWeddingRepository extends Mock implements FirebaseWeddingRepository {}

class MockUserWeddingRepository extends Mock
    implements FirebaseUserWeddingRepository {}

class MockInviteEmailRepository extends Mock
    implements FirebaseInviteEmailRepository {}

class MockUserRepository extends Mock implements FirebaseUserRepository{}
void main() {
  const emptyString = "";
  const validName = "linh le";

  final Wedding wedding = new Wedding(
      validName, validName, DateTime.now(), "default", "address",
      id: "dasd");
  final user = mock_user.MockUser(
    uid: "uid",
    email: "linhle8964@gmail.com",
  );
  group("valid wedding field", () {
    setUp(() {});
    test("initial state is empty", () {
      expect(ValidateWeddingBloc().state, ValidateWeddingState.empty());
    });

    group("Name Changed", () {
      blocTest("emit [invalid] when name is empty",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(GroomNameChanged(groomName: emptyString)),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
                isGroomNameValid: false,
                isBrideNameValid: true,
                isAddressValid: true,
                isBudgetValid: true,
                groomNameErrorMessage: MessageConst.nameTooShort,
                brideNameErrorMessage: "",
                addressErrorMessage: "",
                budgetErrorMessage: "",)
          ]);

      blocTest("emit [invalid] when name too long",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(GroomNameChanged(groomName: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
              isGroomNameValid: false,
              isBrideNameValid: true,
              isAddressValid: true,
              isBudgetValid: true,
              groomNameErrorMessage: MessageConst.nameTooLong,
              brideNameErrorMessage: "",
              addressErrorMessage: "",
              budgetErrorMessage: "",)
          ]);

      blocTest("emit [invalid] when name is null",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(GroomNameChanged(groomName: null)),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
              isGroomNameValid: false,
              isBrideNameValid: true,
              isAddressValid: true,
              isBudgetValid: true,
              groomNameErrorMessage: "",
              brideNameErrorMessage: "",
              addressErrorMessage: "",
              budgetErrorMessage: "",)
          ]);

      blocTest("emit [invalid] when name contain number",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(GroomNameChanged(groomName: "linh112346465")),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
                isGroomNameValid: false,
                isBrideNameValid: true,
                isAddressValid: true,
                isBudgetValid: true,
                groomNameErrorMessage: MessageConst.nameNotContainNumber,
                brideNameErrorMessage: "",
                addressErrorMessage: "",
                budgetErrorMessage: "",)
          ]);

      blocTest("emit [invalid] when name contain special character",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(GroomNameChanged(groomName: "linh@@@@")),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
              isGroomNameValid: false,
              isBrideNameValid: true,
              isAddressValid: true,
              isBudgetValid: true,
              groomNameErrorMessage: MessageConst.nameNotContainSpecialCharacter,
              brideNameErrorMessage: "",
              addressErrorMessage: "",
              budgetErrorMessage: "",)
          ]);

      blocTest("emit [valid] name",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(GroomNameChanged(groomName: validName)),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState(
              isGroomNameValid: false,
              isBrideNameValid: true,
              isAddressValid: true,
              isBudgetValid: true,
            groomNameErrorMessage: "",
            brideNameErrorMessage: "",
            addressErrorMessage: "",
            budgetErrorMessage: "",),
          expect: [
            ValidateWeddingState(
                isGroomNameValid: true,
                isBrideNameValid: true,
                isAddressValid: true,
                isBudgetValid: true,
              groomNameErrorMessage: "",
              brideNameErrorMessage: "",
              addressErrorMessage: "",
              budgetErrorMessage: "",)
          ]);

      blocTest("emit [invalid] when address is empty",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(AddressChanged(address: emptyString)),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
                isGroomNameValid: true,
                isBrideNameValid: true,
                isAddressValid: false,
                isBudgetValid: true,
              groomNameErrorMessage: "",
              brideNameErrorMessage: "",
              addressErrorMessage: MessageConst.addressTooShort,
              budgetErrorMessage: "",)
          ]);

      blocTest("emit [invalid] when address is null",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(AddressChanged(address: null)),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
              isGroomNameValid: true,
              isBrideNameValid: true,
              isAddressValid: false,
              isBudgetValid: true,
              groomNameErrorMessage: "",
              brideNameErrorMessage: "",
              addressErrorMessage: "",
              budgetErrorMessage: "",)
          ]);

      blocTest("emit [invalid] when address length < 6",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(AddressChanged(address: "123 @")),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
              isGroomNameValid: true,
              isBrideNameValid: true,
              isAddressValid: false,
              isBudgetValid: true,
              groomNameErrorMessage: "",
              brideNameErrorMessage: "",
              addressErrorMessage: MessageConst.addressTooShort,
              budgetErrorMessage: "",)
          ]);

      blocTest("emit [invalid] when address is length > 20",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(AddressChanged(address: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
              isGroomNameValid: true,
              isBrideNameValid: true,
              isAddressValid: false,
              isBudgetValid: true,
              groomNameErrorMessage: "",
              brideNameErrorMessage: "",
              addressErrorMessage: MessageConst.addressTooLong,
              budgetErrorMessage: "",)
          ]);

      blocTest("emit [invalid] when budget is smaller than min value",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(BudgetChanged(budget: "100")),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
              isGroomNameValid: true,
              isBrideNameValid: true,
              isAddressValid: true,
              isBudgetValid: false,
              groomNameErrorMessage: "",
              brideNameErrorMessage: "",
              addressErrorMessage: "",
              budgetErrorMessage: MessageConst.budgetMin,)
          ]);

      blocTest("emit [invalid] when budget is bigger than max value",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(BudgetChanged(budget: "10000000000000000000000000000000000000000000")),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
              isGroomNameValid: true,
              isBrideNameValid: true,
              isAddressValid: true,
              isBudgetValid: false,
              groomNameErrorMessage: "",
              brideNameErrorMessage: "",
              addressErrorMessage: "",
              budgetErrorMessage: MessageConst.budgetMax,)
          ]);

      blocTest("emit [invalid] when budget % 1000 != 0",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(BudgetChanged(budget: "1000000002")),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
            ValidateWeddingState(
              isGroomNameValid: true,
              isBrideNameValid: true,
              isAddressValid: true,
              isBudgetValid: false,
              groomNameErrorMessage: "",
              brideNameErrorMessage: "",
              addressErrorMessage: "",
              budgetErrorMessage: MessageConst.budgetTripleZero,)
          ]);

      blocTest("emit [valid] budget",
          build: () => ValidateWeddingBloc(),
          act: (bloc) => bloc.add(BudgetChanged(budget: "10000000")),
          wait: const Duration(milliseconds: 300),
          seed: ValidateWeddingState.empty(),
          expect: [
          ]);
    });
  });

  group("crud wedding", () {
    MockWeddingRepository mockWeddingRepository;
    MockUserWeddingRepository mockUserWeddingRepository;
    MockInviteEmailRepository mockInviteEmailRepository;
    MockUserRepository mockUserRepository;
    setUp(() {
      mockWeddingRepository = MockWeddingRepository();
      mockUserWeddingRepository = MockUserWeddingRepository();
      mockInviteEmailRepository = MockInviteEmailRepository();
      mockUserRepository = MockUserRepository();
    });

    test("initial state is empty", () {
      expect(
          WeddingBloc(
                  weddingRepository: mockWeddingRepository,
                  userWeddingRepository: mockUserWeddingRepository,
                  inviteEmailRepository: mockInviteEmailRepository,
                  userRepository: mockUserRepository)
              .state,
          WeddingLoading());
    });

    test('throws AssertionError when weddingRepository is null', () {
      expect(
          () => WeddingBloc(
              weddingRepository: null,
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository),
          throwsA(isA<AssertionError>()));
    });

    test('throws AssertionError when userWeddingRepository is null', () {
      expect(
          () => WeddingBloc(
              userWeddingRepository: null,
              weddingRepository: mockWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository),
          throwsA(isA<AssertionError>()));
    });

    blocTest("load wedding by id",
        build: () {
          //when(mockFirebaseAuth.currentUser).thenAnswer((_) => user);
          return WeddingBloc(
              weddingRepository: mockWeddingRepository,
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository);
        },
        act: (bloc) => bloc.add(LoadWeddingById(wedding.id)),
        expect: []);

    blocTest("create wedding when user is null",
        build: () {
          when(mockUserRepository.getUser()).thenReturn(null);
          return WeddingBloc(
              weddingRepository: mockWeddingRepository,
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository);
        },
        act: (bloc) => bloc.add(CreateWedding(wedding)),
        expect: <WeddingState>[
          Loading(MessageConst.commonLoading),
          Failed(MessageConst.commonError)
        ]);

    blocTest("create wedding when wedding is null",
        build: () {
          when(mockUserRepository.getUser()).thenAnswer((_) async=> user);
          return WeddingBloc(
              weddingRepository: mockWeddingRepository,
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository);
        },
        act: (bloc) => bloc.add(CreateWedding(null)),
        expect: <WeddingState>[
          Loading(MessageConst.commonLoading),
          Failed(MessageConst.commonError)
        ]);

    blocTest("create wedding",
        build: () {
          when(mockUserRepository.getUser()).thenAnswer((_) async => user);
          return WeddingBloc(
              weddingRepository: mockWeddingRepository,
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository);
        },
        act: (bloc) => bloc.add(CreateWedding(wedding)),
        expect: <WeddingState>[
          Loading(MessageConst.commonLoading),
          Success(MessageConst.createSuccess)
        ]);

    blocTest("update wedding",
        build: () {
          return WeddingBloc(
              weddingRepository: mockWeddingRepository,
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository);
        },
        act: (bloc) => bloc.add(UpdateWedding(wedding)),
        expect: [
          Loading(MessageConst.commonLoading),
          //  Success("Tạo thành công")
        ]);

    blocTest("delete wedding",
        build: () {
          return WeddingBloc(
              weddingRepository: mockWeddingRepository,
              userWeddingRepository: mockUserWeddingRepository,
              inviteEmailRepository: mockInviteEmailRepository,
              userRepository: mockUserRepository);
        },
        act: (bloc) => bloc.add(DeleteWedding(wedding.id)),
        expect: [
          Loading("Đang xử lý dữ liệu"),
          //  Success("Tạo thành công")
        ]);
  });
}
