import 'package:shopapp/Models/Login_Model.dart';

abstract class ShopRegisterStates {}

class ShopRegisterInitialState extends ShopRegisterStates{}

class ShopRegisterLoadingState extends ShopRegisterStates{}

class ShopRegisterSuccessState extends ShopRegisterStates{
  final Shop_Login_Model model;

  ShopRegisterSuccessState(this.model);
}

class ShopRegisterErrorState extends ShopRegisterStates{
  final String error;

  ShopRegisterErrorState(this.error);
}

class ShopRegisterSecureState extends ShopRegisterStates{}