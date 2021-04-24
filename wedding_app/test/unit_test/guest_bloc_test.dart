import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:wedding_app/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/repository/guests_repository.dart';

class MockGuestRepository extends Mock implements FirebaseGuestRepository {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main(){
  const validName = "quan vu";
  final Wedding wedding = new Wedding(validName, validName, DateTime.now(), "default", "address", id: "a123");
  final Guest guest = new Guest("quanvm", "", 0, "0123123123", 0, 0, "", 0);

  group("crud guest", () {
    MockGuestRepository mockGuestRepository;
    MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockGuestRepository = MockGuestRepository();
      mockFirebaseAuth = MockFirebaseAuth();
    });

    test("initial state is empty", (){
      expect(GuestsBloc(guestsRepository: mockGuestRepository).state, GuestsLoading());
    });

    test('throws AssertionError when budgetRepository is null', () {
      expect(() => GuestsBloc(
            guestsRepository:null,
          ),
          throwsA(isA<AssertionError>()));
    });

    blocTest("load budget by weddingid",
        build: () {
          //when(mockFirebaseAuth.currentUser).thenAnswer((_) => user);
          return GuestsBloc(
            guestsRepository: mockGuestRepository,
          );
        },
        act: (bloc) => bloc.add(LoadGuests(wedding.id)),
        expect: []);

    blocTest("create budget",
        build: () {
          when(mockFirebaseAuth.currentUser).thenThrow((_) => Exception());
          return GuestsBloc(
              guestsRepository: mockGuestRepository);

        },
        act: (bloc) => bloc.add(AddGuest(guest, wedding.id)),
        expect: <GuestsState>[
          GuestAdded(),
        ]);

    blocTest("update budget",
        build: () {
          return GuestsBloc(
              guestsRepository: mockGuestRepository);

        },
        act: (bloc) => bloc.add(UpdateGuest(guest,wedding.id)),
        expect: [
          GuestUpdated(),
        ]);

    blocTest("delete budget",
        build: () {
          return GuestsBloc(
              guestsRepository: mockGuestRepository);

        },
        act: (bloc) => bloc.add(DeleteGuest(guest,wedding.id)),
        expect: [
          GuestDeleted(),
        ]);

  });
}