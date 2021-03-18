import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedding_app/bloc/template_card/bloc.dart';
import 'package:wedding_app/bloc/template_card/template_card_event.dart';
import 'package:wedding_app/bloc/template_card/template_card_state.dart';
import 'package:wedding_app/repository/template_card_repository.dart';

class TemplateCardBloc extends Bloc<TemplateCardEvent, TemplateCardState> {
  final TemplateCardRepository _templateCardRepository;
  StreamSubscription _templateCardSubscription;

  TemplateCardBloc({@required TemplateCardRepository templateCardRepository})
      : assert(TemplateCardRepository != null),
        _templateCardRepository = templateCardRepository,
        super(TemplateCardLoading());

  @override
  Stream<TemplateCardState> mapEventToState(TemplateCardEvent event) async*{
    if(event is LoadTemplateCard){
      yield* _mapLoadTemplateCardToState();
    }else if(event is TemplateCardUpdated){
      yield* _mapUpadteTemplateCardToState(event);
    }
  }
  Stream<TemplateCardState> _mapLoadTemplateCardToState() async*{
    _templateCardSubscription?.cancel();
    _templateCardSubscription = _templateCardRepository.GetAllTemplate().listen(
            (template) => add(TemplateCardUpdated(template)),
    );
  }
  Stream<TemplateCardState> _mapUpadteTemplateCardToState(TemplateCardUpdated event) async*{
    yield TemplateCardLoaded(event.template);
  }
  @override
  Future<void> close() {
    _templateCardSubscription?.cancel();
    return super.close();
  }
}