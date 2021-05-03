
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/invitation_card/bloc.dart';
import 'package:wedding_app/firebase_repository/invitation_card_firebase_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_app/model/invitation_card.dart';
import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/screens/choose_template_invitation/fill_info_page.dart';

class MockInvitationCardRepository extends Mock implements FirebaseInvitationCardRepository {}

class MockUserWeddingRepository extends Mock
    implements FirebaseUserWeddingRepository {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  const validName = "linh le";
  final Category category= new Category("asd","test");
  final Wedding wedding = new Wedding(
      validName, validName, DateTime.now(), "default", "address",
      id: "dasd");

  final InvitationCard card  = new InvitationCard(id: '1',url: '234234');

  test('brideName has input less than 2 character', (){
      var result = BrideNameValidator.validate('a');
      expect(result, 'Số lượng kí tự ít hơn 2 kí tự');
  });
  test('brideName has input more than 20 character', (){
      var result = BrideNameValidator.validate('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      expect(result, 'Số lượng kí tự quá 20 kí tự');
  });
  test('brideName has input has special character', (){
      var result = BrideNameValidator.validate('Nguyễn Thị Thu@');
      expect(result, 'Tên người nhập không có số hay kí tự đặc biệt');
  });
  test('brideName has input has numeric character', (){
      var result = BrideNameValidator.validate('Nguyễn Thị Thu11');
      expect(result, 'Tên người nhập không có số hay kí tự đặc biệt');
  });
  test('brideName has input has no input', (){
      var result = BrideNameValidator.validate('');
      expect(result, null);
  });
  test('groomName has input less than 2 character', (){
      var result = GroomNameValidator.validate('a');
      expect(result, 'Số lượng kí tự ít hơn 2 kí tự');
  });
  test('groomName has input more than 20 character', (){
      var result = GroomNameValidator.validate('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      expect(result, 'Số lượng kí tự quá 20 kí tự');
  });
  test('groomName has input has special character', (){
      var result = GroomNameValidator.validate('Nguyễn Thị Thu@');
      expect(result, 'Tên người nhập không có số hay kí tự đặc biệt');
  });
  test('groomName has input has numeric character', (){
      var result = GroomNameValidator.validate('Nguyễn Thị Thu11');
      expect(result, 'Tên người nhập không có số hay kí tự đặc biệt');
  });
  test('groomName has input has no input', (){
      var result = GroomNameValidator.validate('');
      expect(result, null);
  });

  test('Place has input less than 2 character', (){
      var result = GroomNameValidator.validate('a');
      expect(result, 'Số lượng kí tự ít hơn 2 kí tự');
  });
  test('Place has input more than 20 character', (){
      var result = GroomNameValidator.validate('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      expect(result, 'Số lượng kí tự quá 20 kí tự');
  });
  test('Place has input has special character', (){
      var result = GroomNameValidator.validate('Nguyễn Thị Thu@');
      expect(result, 'Tên địa chỉ không có kí tự đặc biệt');
  });
  test('Place has input has no input', (){
      var result = GroomNameValidator.validate('');
      expect(result, null);
  });

  group("crud invitationCard", () {
    MockInvitationCardRepository mockInvitationCardRepository;
    MockUserWeddingRepository mockUserWeddingRepository;
    MockFirebaseAuth mockFirebaseAuth;
    setUp(() {
      mockInvitationCardRepository = MockInvitationCardRepository();
      mockUserWeddingRepository = MockUserWeddingRepository();
      mockFirebaseAuth = MockFirebaseAuth();
    });

    test("initial state is empty", () {
      expect(
          InvitationCardBloc(
                  invitationCardRepository:mockInvitationCardRepository ,

                 )
              .state,
          InvitationCardLoading());
    });

    


    blocTest("load InvitationCard by weddingid",
        build: () {
          //when(mockFirebaseAuth.currentUser).thenAnswer((_) => user);
          return InvitationCardBloc(
              invitationCardRepository: mockInvitationCardRepository,
             );
        },
        act: (bloc) => bloc.add(LoadSuccess(wedding.id)),
        expect: []);

    blocTest("create InvitationCard",
        build: () {
          when(mockFirebaseAuth.currentUser).thenThrow((_) => Exception());
          return InvitationCardBloc(
              invitationCardRepository: mockInvitationCardRepository);

        },
        act: (bloc) => bloc.add(AddInvitationCard(card,wedding.id)),
        expect: <InvitationCardState>[
         InvitationCardAdded()
          //  Success("Tạo thành công")
        ]);

  });
}
