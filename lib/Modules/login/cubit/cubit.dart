import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Models/Login_Model.dart';
import 'package:shopapp/Modules/login/cubit/states.dart';
import 'package:shopapp/Network/Remote/dio_Helper.dart';
import 'package:shopapp/Network/end_points.dart';
import 'package:shopapp/cubit/cubit.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>{

  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  late Shop_Login_Model loginModel;

  bool isSecure = true;

  IconData passIcon = Icons.visibility_off;

  void userLogin(context,{required String Email , required String Password})
  {
    emit(ShopLoginLoadingState());

    DioHelper.postData(
        url: LOGIN,
        data:
        {
          'email' : Email,
          'password' : Password
        },
        lang: ShopCubit.get(context).getDioLang()
    )!.then((value)
    {
      // print(value.data);
      loginModel = Shop_Login_Model.fromJson(value.data);
      //print(loginModel.status);
     // print(loginModel.data);
      emit(ShopLoginSuccessState(loginModel));
    }).catchError((err)
    {
      print(err.toString());
      emit(ShopLoginErrorState(err.toString()));
    });
  }

  void changePassVisibility()
  {
    isSecure =! isSecure;
    if(isSecure)
    {
      passIcon = Icons.visibility_off;
    }
    else
    {
      passIcon = Icons.visibility;
    }
    emit(ShopLoginSecureState());
  }

}