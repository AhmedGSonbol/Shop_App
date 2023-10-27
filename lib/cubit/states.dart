import 'package:shopapp/Models/Login_Model.dart';
import 'package:shopapp/Models/cart_Model.dart';
import 'package:shopapp/Models/chnage_favorites_Model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates{}

class ShopChangeBottomNavState extends ShopStates{}

class ShopChangeAppModeState extends ShopStates{}

class ShopChangeAppLangState extends ShopStates{}


class ShopLoadingHomeDataState extends ShopStates{}
class ShopSuccessHomeDataState extends ShopStates{}
class ShopErrorHomeDataState extends ShopStates{}

class ShopSuccessCategoriesDataState extends ShopStates{}
class ShopErrorCategoriesDataState extends ShopStates{}

class ShopSuccessCategoriesDetailsDataState extends ShopStates{}
class ShopErrorCategoriesDetailsDataState extends ShopStates{}

class ShopSuccessChangeFavoritesState extends ShopStates {
  final Change_Favorites_Model model;

  ShopSuccessChangeFavoritesState(this.model);
}
class ShopChangeFavoritesState extends ShopStates{}
class ShopErrorChangeFavoritesState extends ShopStates{}

class ShopSuccessGetFavoritesDataState extends ShopStates{}
class ShopErrorGetFavoritesDataState extends ShopStates{}
class ShopLoadingFavoritesDataState extends ShopStates{}

class ShopLoadingUserDataState extends ShopStates{}
class ShopSuccessUserDataState extends ShopStates {
  Shop_Login_Model user_Model;

  ShopSuccessUserDataState(this.user_Model);

}
class ShopErrorUserDataState extends ShopStates{}

class ShopLoadingUpdateUserDataState extends ShopStates{}
class ShopSuccessUpdateUserDataState extends ShopStates {
  Shop_Login_Model user_Model;

  ShopSuccessUpdateUserDataState(this.user_Model);

}
class ShopErrorUpdateUserDataState extends ShopStates{}

class ShopLoadingCartItemsState extends ShopStates{}
class ShopSuccessCartItemsState extends ShopStates{
  // Cart_Model cart_model;
  //
  // ShopSuccessCartItemsState(this.cart_model);
}
class ShopErrorCartItemsState extends ShopStates{}

class ShopLoadingUpdateCartItemsState extends ShopStates{}
class ShopSuccessUpdateCartItemsState extends ShopStates{
  // Cart_Model cart_model;
  //
  // ShopSuccessUpdateCartItemsState(this.cart_model);
}
class ShopErrorUpdateCartItemsState extends ShopStates{}

class ShopChangeBottomSheetState extends ShopStates{}