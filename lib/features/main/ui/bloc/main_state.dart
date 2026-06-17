part of 'main_bloc.dart';

class MainState {
  final NavigationItems selectedItem;

  MainState({this.selectedItem = NavigationItems.dashboard});

  MainState copyWith({NavigationItems? selectedItem}) {
    return MainState(selectedItem: selectedItem ?? this.selectedItem);
  }
}
