import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/domain/enums/navigation_items.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState()) {
    on<OnNavigationItemTapped>(_onNavigationItemTapped);
  }

  void _onNavigationItemTapped(
    OnNavigationItemTapped event,
    Emitter<MainState> emit,
  ) {
    emit(state.copyWith(selectedItem: event.item));
  }

  void selectNavigationItem(NavigationItems item) {
    add(OnNavigationItemTapped(item: item));
  }
}
