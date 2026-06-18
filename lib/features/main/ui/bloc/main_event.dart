part of 'main_bloc.dart';

abstract class MainEvent {}

class OnNavigationItemTapped extends MainEvent {

  OnNavigationItemTapped({required this.item});
  final NavigationItems item;
}
