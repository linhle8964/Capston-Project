
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_diary/bloc/vendor/bloc.dart';
import 'package:flutter_web_diary/firebase_repository/vendor_firebase_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_web_diary/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:flutter_web_diary/model/vendor.dart';
import 'package:flutter_web_diary/model/category.dart';


class MockVendorRepository extends Mock implements FirebaseVendorRepository {}

class MockUserWeddingRepository extends Mock
    implements FirebaseUserWeddingRepository {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  const validName = "linh le";
  final Category category= new Category("asd","test");
  final Vendor vendor = new Vendor("label", "name", 'cateID','location', 'description', 'frontImage', "ownerImage",'email','phone');
  
  group("crud vendor", () {
     MockVendorRepository mockVendorRepository;
     MockUserWeddingRepository mockUserWeddingRepository;
     MockFirebaseAuth mockFirebaseAuth;
     mockVendorRepository = MockVendorRepository();
      mockUserWeddingRepository = MockUserWeddingRepository();
      mockFirebaseAuth = MockFirebaseAuth();
    setUp(() {
      mockVendorRepository = MockVendorRepository();
      mockUserWeddingRepository = MockUserWeddingRepository();
      mockFirebaseAuth = MockFirebaseAuth();
    });

    test("initial state is empty", () {
      expect(
          VendorBloc(
                  todosRepository: mockVendorRepository,
                 )
              .state,
          VendorLoading());
    });

    test('throws AssertionError when VendorRepository is null', () {
      expect(
          () => VendorBloc(
              todosRepository:null,
             ),
          throwsA(isA<AssertionError>()));
    });



    blocTest("load all vendor ",
        build: () {
          //when(mockFirebaseAuth.currentUser).thenAnswer((_) => user);
          return VendorBloc(
              todosRepository: mockVendorRepository,
             );
        },

        act: (bloc) => bloc.add(GetAllVendor()),
        expect: []);

    blocTest("create vendor",
        build: () {
          when(mockFirebaseAuth.currentUser).thenThrow((_) => Exception());
          return VendorBloc(
              todosRepository: mockVendorRepository);

        },
        act: (bloc) => bloc.add(AddVendor(vendor)),
        expect: <VendorState>[
          Loading("Đang xử lý dữ liệu"),
          Success("Tạo thành công")
          //  Success("Tạo thành công")
        ]);

    blocTest("update vendor",
        build: () {
          //when(mockFirebaseAuth.currentUser).thenAnswer((_) => user);
          return VendorBloc(
              todosRepository: mockVendorRepository);

        },
        act: (bloc) {
          return bloc.add(UpdateVendor(vendor));
        },
        expect: [
         VendorUpdate()
        ]);
   
    blocTest("delete vendor",
        build: () {
          //when(mockFirebaseAuth.currentUser).thenAnswer((_) => user);
          return VendorBloc(
              todosRepository: mockVendorRepository);

        },
        act: (bloc) => bloc.add(DeleteVendor(vendor.id)),
        expect: [
        ]);
  });
}
