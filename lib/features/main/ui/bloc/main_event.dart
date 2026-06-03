part of 'main_bloc.dart';

abstract class MainEvent {}

class OnNavigationItemTapped extends MainEvent {
  final NavigationItems item;

  OnNavigationItemTapped({required this.item});
}
