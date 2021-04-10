import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_web_diary/bloc/category/bloc.dart';
import 'package:flutter_web_diary/bloc/vendor/vendor_bloc_event.dart';
import 'package:flutter_web_diary/bloc/vendor/vendor_bloc_state.dart';
import 'package:flutter_web_diary/repository/category_repository.dart';
import 'package:flutter_web_diary/repository/vendor_repository.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final VendorRepository _vendorRepository;
  StreamSubscription _vendorSubscription;

  VendorBloc({@required VendorRepository todosRepository})
      : assert(todosRepository != null),
        _vendorRepository = todosRepository,
        super(VendorLoading());

  @override
  Stream<VendorState> mapEventToState(VendorEvent event) async* {
    if (event is LoadVendor) {
      yield* _mapLoadVendorToState();
    } else if (event is VendorUpdated) {
      yield* _mapVendorUpdateToState(event);
    }
  }

  Stream<VendorState> _mapLoadVendorToState() async* {
    _vendorSubscription?.cancel();
    _vendorSubscription = _vendorRepository.getallVendor().listen(
          (vendors) => add(VendorUpdated(vendors)),
        );
  }

  Stream<VendorState> _mapVendorUpdateToState(VendorUpdated event) async* {
    yield VendorLoaded(event.vendors);
  }

  @override
  Future<void> close() {
    _vendorSubscription?.cancel();
    return super.close();
  }
}
