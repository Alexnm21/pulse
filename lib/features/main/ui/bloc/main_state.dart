part of 'main_bloc.dart';

class MainState {

  MainState({this.selectedItem = NavigationItems.dashboard});
  final NavigationItems selectedItem;

  MainState copyWith({NavigationItems? selectedItem}) {
    return MainState(selectedItem: selectedItem ?? this.selectedItem);
  }
}
