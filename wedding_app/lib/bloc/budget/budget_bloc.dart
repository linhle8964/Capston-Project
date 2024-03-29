import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:wedding_app/bloc/budget/budget_bloc_event.dart';
import 'package:wedding_app/bloc/budget/budget_bloc_state.dart';
import 'package:wedding_app/repository/budget_repository.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepository _budgetRepository;
  StreamSubscription _streamSubscription;

  BudgetBloc({@required BudgetRepository budgetRepository})
      : assert(budgetRepository != null),
        _budgetRepository = budgetRepository,
        super(BudgetLoading());

  @override
  Stream<BudgetState> mapEventToState(BudgetEvent event) async* {
    if (event is CreateBudget) {
      yield* _mapCreateWeddingToState(event);
    } else if (event is UpdateBudget) {
      yield* _mapUpdateWeddingToState(event);
    } else if (event is DeleteBudget) {
      yield* _mapDeleteWeddingToState(event);
    } else if (event is UpadatedBudget) {
      yield* _mapWeddingUpdatedToState(event);
    } else if (event is LoadBudgetbyCateId) {
      yield* _mapGetBudgetByCateIdToState(event);
    } else if (event is GetAllBudget) {
      yield* _mapGetAllBudgetToState(event);
    }
  }

  // Stream<WeddingState> _mapLoadWeddingsToState(LoadWeddings event) async* {
  //   _streamSubscription?.cancel();
  //   _streamSubscription = _weddingRepository.getAllWedding().listen(
  //         (weddings) => add(WeddingUpdated(weddings)),
  //       );
  // }

  Stream<BudgetState> _mapCreateWeddingToState(CreateBudget event) async* {
    yield Loading("Đang xử lý dữ liệu");
    try {
      await _budgetRepository.createBudget(event.wedding, event.budget);
      yield Success("Tạo thành công");
    } catch (_) {
      yield Failed("Có lỗi xảy ra");
    }
  }

  Stream<BudgetState> _mapGetBudgetByCateIdToState(
      LoadBudgetbyCateId event) async* {

    _streamSubscription = _budgetRepository
        .getBudgetByCateId(event.weddingId, event.cateId)
        .listen(
          (budgets) => add(UpadatedBudget(budgets)),
        );
    yield Success("Load thanh cong");
  }

  Stream<BudgetState> _mapGetAllBudgetToState(GetAllBudget event) async* {
    _streamSubscription =
        _budgetRepository.getAllBudget(event.weddingId).listen(
              (budgets) => add(UpadatedBudget(budgets)),
            );
  }

  Stream<BudgetState> _mapUpdateWeddingToState(UpdateBudget event) async* {
    yield Loading("Đang xử lý dữ liệu");
    try {
      await _budgetRepository.updateBudget(event.weddingId, event.updatedBudget);
      yield Success("update thành công");
      yield BudgetUpdate();
    } catch (_) {
      yield Failed("Có lỗi xảy ra");
    }


  }

  Stream<BudgetState> _mapDeleteWeddingToState(DeleteBudget event) async* {
    yield Loading("Đang xử lý dữ liệu");
    try {
      await _budgetRepository.deleteBudget(event.weddingId, event.budgetId);
      yield Success("Delete thành công");
    } catch (_) {
      yield Failed("Có lỗi xảy ra");
    }

  }

  Stream<BudgetState> _mapWeddingUpdatedToState(UpadatedBudget event) async* {
    yield BudgetLoaded(event.budgets);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
