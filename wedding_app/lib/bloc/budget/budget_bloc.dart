import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:wedding_app/bloc/budget/budget_bloc_event.dart';
import 'package:wedding_app/bloc/budget/budget_bloc_state.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/repository/budget_repository.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:wedding_app/repository/wedding_repository.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {


  final BudgetRepository _budgetRepository;
  StreamSubscription _streamSubscription;

  BudgetBloc({@required String weddingId,
    @required BudgetRepository budgetRepository})
      :
        assert(budgetRepository != null),

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
    } else if (event is BudgetUpdated) {
      yield* _mapWeddingUpdatedToState(event);
    }else if (event is LoadBudgetbyCateId) {
      yield* _mapGetBudgetByCateIdToState(event);
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
      await _budgetRepository.createBudget(event.wedding,event.budget);
      yield Success("Tạo thành công");
    } catch (_) {
      yield Failed("Có lỗi xảy ra");
    }
  }
  Stream<BudgetState> _mapGetBudgetByCateIdToState(LoadBudgetbyCateId event) async* {
    _streamSubscription = _budgetRepository.getBudgetByCateId(event.weddingId, event.cateId).listen(
          (budgets) => add(BudgetUpdated(budgets)),
    );

  }
  Stream<BudgetState> _mapUpdateWeddingToState(UpdateBudget event) async* {
    _budgetRepository.updateBudget(event.weddingId,event.updatedBudget);
    yield BudgetUpdate();
  }

  Stream<BudgetState> _mapDeleteWeddingToState(DeleteBudget event) async* {
 _budgetRepository.deleteBudget(event.weddingId, event.budgetId);
  }

  Stream<BudgetState> _mapWeddingUpdatedToState(BudgetUpdated event) async* {
    yield BudgetLoaded(event.budgets);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
