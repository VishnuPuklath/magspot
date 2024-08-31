import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mag_bloc_event.dart';
part 'mag_bloc_state.dart';

class MagBlocBloc extends Bloc<MagBlocEvent, MagBlocState> {
  MagBlocBloc() : super(MagBlocInitial()) {
    on<MagBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
