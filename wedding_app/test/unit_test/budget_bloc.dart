import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/budget/bloc.dart';
import 'package:wedding_app/firebase_repository/budget_firebase_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/model/wedding.dart';

class MockBudgetRepository extends Mock implements FirebaseBudgetRepository {}

class MockUserWeddingRepository extends Mock
    implements FirebaseUserWeddingRepository {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  const validName = "linh le";
  final Category category = new Category("asd", "test");
  final Wedding wedding = new Wedding(
      validName, validName, DateTime.now(), "default", "address",
      id: "dasd");

  final Budget budget =
      new Budget("abczxc", "test123", true, 10000, 10000, 1, "note");
  group("crud budget", () {
    MockBudgetRepository mockBudgetRepository;
    MockFirebaseAuth mockFirebaseAuth;
    setUp(() {
      mockBudgetRepository = MockBudgetRepository();
      mockFirebaseAuth = MockFirebaseAuth();
    });
    test("initial state is empty", () {
      expect(
          BudgetBloc(
            budgetRepository: mockBudgetRepository,
          ).state,
          BudgetLoading());
    });

    test('throws AssertionError when budgetRepository is null', () {
      expect(
          () => BudgetBloc(
                budgetRepository: null,
              ),
          throwsA(isA<AssertionError>()));
    });

    blocTest("load budget by weddingid",
        build: () {
          //when(mockFirebaseAuth.currentUser).thenAnswer((_) => user);
          return BudgetBloc(
            budgetRepository: mockBudgetRepository,
          );
        },
        act: (bloc) => bloc.add(GetAllBudget(wedding.id)),
        expect: []);

    blocTest("create budget",
        build: () {
          when(mockFirebaseAuth.currentUser).thenThrow((_) => Exception());
          return BudgetBloc(budgetRepository: mockBudgetRepository);
        },
        act: (bloc) => bloc.add(CreateBudget(wedding.id, budget)),
        expect: <BudgetState>[
          Loading("Đang xử lý dữ liệu"),
          Success("Tạo thành công")
          //  Success("Tạo thành công")
        ]);

    blocTest("update budget",
        build: () {
          //when(mockFirebaseAuth.currentUser).thenAnswer((_) => user);
          return BudgetBloc(budgetRepository: mockBudgetRepository);
        },
        act: (bloc) => bloc.add(UpdateBudget(budget, wedding.id)),
        expect: [
          Loading("Đang xử lý dữ liệu"),
          Success("update thành công"),
          BudgetUpdate()
        ]);
    blocTest("load budget by cateId",
        build: () {
          //when(mockFirebaseAuth.currentUser).thenAnswer((_) => user);
          return BudgetBloc(budgetRepository: mockBudgetRepository);
        },
        act: (bloc) => bloc.add(LoadBudgetbyCateId(category.id, wedding.id)),
        expect: []);
    blocTest("delete budget",
        build: () {
          //when(mockFirebaseAuth.currentUser).thenAnswer((_) => user);
          return BudgetBloc(budgetRepository: mockBudgetRepository);
        },
        act: (bloc) => bloc.add(DeleteBudget(wedding.id, budget.id)),
        expect: [
          Loading("Đang xử lý dữ liệu"),
          Success("Delete thành công")
          //  Success("Tạo thành công")
        ]);
  });
}
