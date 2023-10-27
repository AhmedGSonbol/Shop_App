import 'package:shopapp/Models/Login_Model.dart';

abstract class ShopLoginStates {}

class ShopLoginInitialState extends ShopLoginStates{}

class ShopLoginLoadingState extends ShopLoginStates{}

class ShopLoginSuccessState extends ShopLoginStates{
  final Shop_Login_Model model;

  ShopLoginSuccessState(this.model);
}

class ShopLoginErrorState extends ShopLoginStates{
  final String error;

  ShopLoginErrorState(this.error);
}

class ShopLoginSecureState extends ShopLoginStates{}