import 'package:shopapp/Models/change_cart_Model.dart';

abstract class ProductDetailsStates{}

class ProductDetailsInitialState extends ProductDetailsStates{}

class ProductDetailsLoadingState extends ProductDetailsStates{}

class ProductDetailsSuccessState extends ProductDetailsStates{}

class ProductDetailsErrorState extends ProductDetailsStates{}

class ProductDetailsCartLoadingState extends ProductDetailsStates{}

class ProductDetailsCartSuccessState extends ProductDetailsStates
{
  Change_Cart_Model model;

  ProductDetailsCartSuccessState(this.model);

}

class ProductDetailsCartErrorState extends ProductDetailsStates{}

class ProductDetailsFavChangeState extends ProductDetailsStates{}

class ProductDetailsSelectedImageChangeState extends ProductDetailsStates{}