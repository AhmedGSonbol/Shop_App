import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Models/change_cart_Model.dart';
import 'package:shopapp/Models/product_Details_Model.dart';
import 'package:shopapp/Modules/products_Details/cubit/states.dart';
import 'package:shopapp/Network/Remote/dio_Helper.dart';
import 'package:shopapp/Network/end_points.dart';
import 'package:shopapp/components/constants.dart';
import 'package:shopapp/cubit/cubit.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates>
{
  ProductDetailsCubit() : super(ProductDetailsInitialState());

  static ProductDetailsCubit get(context) => BlocProvider.of(context);


  bool? inFav = false;
  bool? inCart = false;

  Product_Details_Model? productDetailsModel;


  void getProductDetails(int id , context)
  {
    emit(ProductDetailsLoadingState());

    DioHelper.getData(
      url: SEARCH_PRODUCT + id.toString(),
      token: token,
      lang: ShopCubit.get(context).getDioLang(),

    )!.then((value)
    {
      productDetailsModel = Product_Details_Model.fromJson(value.data);

      inFav = productDetailsModel!.data!.in_favorites;
      inCart = productDetailsModel!.data!.in_cart;

      emit(ProductDetailsSuccessState());

    }).catchError((err)
    {
      emit(ProductDetailsErrorState());
      print(err.toString());

    });
  }

  Change_Cart_Model? cartModel;
  void change_Cart(int productID , context)
  {
    inCart = !inCart!;

    emit(ProductDetailsCartLoadingState());

    DioHelper.postData(
        url: CART,
        data: {'product_id' : productID},
        token: token,
      lang:ShopCubit.get(context).getDioLang(),
    )!.then((value)
    {
      cartModel = Change_Cart_Model.fromJson(value.data);

      //getProductDetails(productID);

      emit(ProductDetailsCartSuccessState(cartModel!));

      ShopCubit.get(context).getCartItems(isAdd: true);

    }).catchError((err)
    {
      inCart = !inCart!;
      print(err.toString());
      emit(ProductDetailsCartErrorState());
    });

  }
  void changeFav()
  {
    inFav = !inFav!;
    emit(ProductDetailsFavChangeState());
  }

  int selectedImageIndex = 0;
  void changeSelectedImage(int index)
  {
    selectedImageIndex = index;
    emit(ProductDetailsSelectedImageChangeState());
  }

}