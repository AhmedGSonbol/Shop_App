import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Models/Login_Model.dart';
import 'package:shopapp/Models/cart_Model.dart';
import 'package:shopapp/Models/categories_Details_Model.dart';
import 'package:shopapp/Models/categories_Model.dart';
import 'package:shopapp/Models/chnage_favorites_Model.dart';
import 'package:shopapp/Models/favorites_Model.dart';
import 'package:shopapp/Models/home_Model.dart';
import 'package:shopapp/Modules/categories/categories_Screen.dart';
import 'package:shopapp/Modules/favorites/favorites_Screen.dart';
import 'package:shopapp/Modules/products/products_Screen.dart';
import 'package:shopapp/Modules/products_Details/cubit/cubit.dart';
import 'package:shopapp/Modules/settings/settings_Screen.dart';
import 'package:shopapp/Network/Local/Cach_Helper.dart';
import 'package:shopapp/Network/Remote/dio_Helper.dart';
import 'package:shopapp/Network/end_points.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/components/constants.dart';
import 'package:shopapp/cubit/states.dart';

class ShopCubit extends Cubit<ShopStates>
{
  ShopCubit() : super(ShopInitialState());


  static ShopCubit get(context) => BlocProvider.of(context);


  int current_index = 0;

  List<Widget> bottomScreens =
  [
    Products_Screen(),
    Categories_Screen(),
    Favorites_Screen(),
    Settings_Screen(),
  ];

  void changeBottom(int index)
  {
    if(!isBottomSheetShow)
    {
      current_index = index;
      emit(ShopChangeBottomNavState());
    }

  }

  bool isDarkMode = false;

  void changeDarkMode()
  {
    isDarkMode = !isDarkMode;
    CachHelper.saveData(key: 'isdarkmode', value: isDarkMode).then((value)
    {
      emit(ShopChangeAppModeState());

    });
  }

  bool isEnglish = true;

  void changeLang()
  {
    isEnglish = !isEnglish;
    CachHelper.saveData(key: 'isEnglish', value: isEnglish).then((value)
    {
      emit(ShopChangeAppLangState());

      refresh();

    });
  }

  void refresh()
  {
    getHomeData();
    getCategoriesData();
    getFavoritesData();
    getCartItems();
    getUserData();
  }

  String getDioLang()
  {
    if(isEnglish == true)
    {
      return 'en';
    }
    else
    {
      return 'ar';
    }


  }

   Map<int? , bool?> infavourites = {};

  HomeModel? homemodel;
  void getHomeData()
  {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
        url: HOME ,
      token: token,
      lang: getDioLang(),
    )!.then((value)
    {
      print(token);
      homemodel = HomeModel.fromJson(value.data);

      homemodel!.data!.products.forEach((element)
      {
        infavourites.addAll({
          element.id:element.in_favorites
        });
      });
      
     // printFullText(homemodel!.status.toString());

      emit(ShopSuccessHomeDataState());
    }).catchError((err)
    {
      emit(ShopErrorHomeDataState());
      print(err.toString());
    });

  }

  Categories_Model? categoryModel;
  void getCategoriesData()
  {

    DioHelper.getData(
      url: CATEGORIES ,
      token: token,
      lang: getDioLang(),
    )!.then((value)
    {
      categoryModel = Categories_Model.fromJson(value.data);

      //printFullText(categoryModel!.status.toString());

      emit(ShopSuccessCategoriesDataState());
    }).catchError((err)
    {
      emit(ShopErrorCategoriesDataState());
      print(err.toString());
    });

  }

  Categories_Details_Model? categoryDetailsModel;
  void getCategoriesDetailsData(int id)
  {

    DioHelper.getData(
      url: '${CATEGORIES+ '\\' + id.toString()}',
      token: token,
      lang: getDioLang(),
    )!.then((value)
    {
      categoryDetailsModel = Categories_Details_Model.fromJson(value.data);


      emit(ShopSuccessCategoriesDetailsDataState());
    }).catchError((err)
    {
      emit(ShopErrorCategoriesDetailsDataState());
      print(err.toString() + id.toString());

    });

  }

  Change_Favorites_Model? change_favorites_Model;
  void changeFavorites(int? productID ,{bool isProductDetails = false , context})
  {
    infavourites[productID] =! infavourites[productID]!;

    if(isProductDetails)
    {
      ProductDetailsCubit.get(context).changeFav() ;
    }

    emit(ShopChangeFavoritesState());

    DioHelper.postData(
        url: FAVORITES,
        data:
        {
          'product_id':productID
        },
        token: token,
      lang: getDioLang(),
    )!.then((value)
    {
      change_favorites_Model = Change_Favorites_Model.fromJson(value.data);
      if(change_favorites_Model!.status == false)
      {
        infavourites[productID] =! infavourites[productID]!;
        if(isProductDetails)
        {
          ProductDetailsCubit.get(context).changeFav() ;
        }
      }
      else
      {
        getFavoritesData();
      }

      // if(isProductDetails)
      // {
      //   ProductDetailsCubit.get(context).getProductDetails(productID!);
      // }

      emit(ShopSuccessChangeFavoritesState(change_favorites_Model!));
    }).catchError((err)
    {
      if(isProductDetails)
      {
        ProductDetailsCubit.get(context).changeFav() ;
      }
      infavourites[productID] =! infavourites[productID]!;
      emit(ShopErrorChangeFavoritesState());
    });

  }

  Favorites_Model? favorites_model;
  void getFavoritesData()
  {
    emit(ShopLoadingFavoritesDataState());

    DioHelper.getData(
      url: FAVORITES ,
      token: token,
      lang: getDioLang(),
    )!.then((value)
    {
      favorites_model = Favorites_Model.fromJson(value.data);

     // printFullText(value.data.toString());

      emit(ShopSuccessGetFavoritesDataState());
    }).catchError((err)
    {
      emit(ShopErrorGetFavoritesDataState());
      print(err.toString());
    });

  }

  Shop_Login_Model? user_model;
  void getUserData()
  {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE ,
      token: token,
      lang: getDioLang(),
    )!.then((value)
    {
      user_model = Shop_Login_Model.fromJson(value.data);

    //  printFullText(user_model!.data!.name.toString());

      emit(ShopSuccessUserDataState(user_model!));
    }).catchError((err)
    {
      emit(ShopErrorUserDataState());
      print(err.toString());
    });

  }

  void updateUserData({required String name,required String email,required String phone,required String password,})
  {
    emit(ShopLoadingUpdateUserDataState());

    DioHelper.putData(
      url: UPDATE ,
      token: token,
        lang: getDioLang(),
      data: {
        'name': name,
        'phone' : phone,
        'email' : email,
        'password' : password,

      }
    )!.then((value)
    {
      user_model = Shop_Login_Model.fromJson(value.data);

      //  printFullText(user_model!.data!.name.toString());

      emit(ShopSuccessUpdateUserDataState(user_model!));
    }).catchError((err)
    {
      emit(ShopErrorUpdateUserDataState());
      print(err.toString());
    });

  }



 // int cartItemsCount = 0;

  Map<int?,int?> cartItemMap = {};

  double? total ;

  Cart_Model? cart_model;

  void getCartItems({bool isAdd = false})
  {
    emit(ShopLoadingCartItemsState());

    DioHelper.getData(
      url: CART,
      token: token,
      lang: getDioLang(),
    )!.then((value)
    {

      cart_model = Cart_Model.fromJson(value.data);


      //cartItemsCount = cart_model!.data!.cart_items.length;

      if(cartItemMap.isEmpty || isAdd)
      {
        total = double.parse(cart_model!.data!.total.toString());

        cartItemMap = {};
        cart_model!.data!.cart_items.forEach((element)
        {
          cartItemMap.addAll({
            element.cart_item_id:element.quantity
          });
        });
      }

      emit(ShopSuccessCartItemsState());

    }).catchError((err)
    {
      emit(ShopErrorCartItemsState());
      print(err.toString());
    });
  }

  bool isBottomSheetShow = false;

  void changeBottomSheet(bool isVisible)
  {
    isBottomSheetShow = isVisible;
    emit(ShopChangeBottomSheetState());

  }


  void updateCartItems(int itemID,double price , bool isPlus)
  {
    emit(ShopLoadingUpdateCartItemsState());

    if(isPlus)
    {
      cartItemMap[itemID] = cartItemMap[itemID]! + 1 ;
      total = total! + price;
    }
    else
    {
      cartItemMap[itemID] = cartItemMap[itemID]! - 1 ;
      total = total! - price;
    }

    DioHelper.putData(
      data: {'quantity':'${cartItemMap[itemID]}'},
      url: '${CART + '\\' + itemID.toString()}',
      token: token,
      lang: getDioLang(),
    )!.then((value)
    {

      emit(ShopSuccessUpdateCartItemsState());



    }).catchError((err)
    {
      emit(ShopErrorUpdateCartItemsState());
      print(err.toString());

      if(isPlus)
      {
        cartItemMap[itemID] = cartItemMap[itemID]! - 1 ;
        total = total! - price;
      }
      else
      {
        cartItemMap[itemID] = cartItemMap[itemID]! + 1 ;
        total = total! + price;
      }
    });
  }



}

