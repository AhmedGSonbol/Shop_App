import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Modules/home/shopLayout.dart';
import 'package:shopapp/Modules/login/shopLoginScreen.dart';
import 'package:shopapp/Modules/onBoarding/onBoardingScreen.dart';
import 'package:shopapp/Modules/products_Details/cubit/cubit.dart';
import 'package:shopapp/Network/Local/Cach_Helper.dart';
import 'package:shopapp/Network/Remote/dio_Helper.dart';
import 'package:shopapp/Styles/themes.dart';
import 'package:shopapp/classes/bloc_observer.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/components/constants.dart';
import 'package:shopapp/cubit/cubit.dart';
import 'package:shopapp/cubit/states.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CachHelper.init();

  bool isDark = false;
  bool isEnglish = true;
  Widget Screen;



  if(CachHelper.getData(key: 'isdarkmode')!= null)
  {
    isDark = CachHelper.getData(key: 'isdarkmode');
  }

  if(CachHelper.getData(key: 'isEnglish')!= null)
  {
    isEnglish = CachHelper.getData(key: 'isEnglish');
  }



  if(CachHelper.getData(key: 'ShowBoarding') != null)
  {
    if(CachHelper.getData(key: 'token') != null )
    {
      Screen = ShopLayout();
      token = CachHelper.getData(key: 'token');
    }
    else
    {
      Screen = ShopLoginScreen();
    }

  }
  else
  {
    Screen = OnBoardingScreen();
  }


  runApp(HomeMainPage(isdark: isDark, Screen: Screen,isEnglish: isEnglish,));
}

class HomeMainPage extends StatelessWidget
{

  bool isdark;
  bool isEnglish;
  Widget Screen;

  HomeMainPage({required this.isdark , required this.Screen ,required this.isEnglish});


  Widget build(BuildContext context)
  {
        return MultiBlocProvider(
          providers: 
          [
            BlocProvider(create: (context) => ShopCubit()..isDarkMode = isdark..isEnglish=isEnglish
               ..getHomeData()..getCategoriesData()..getFavoritesData()..getUserData()..getCartItems()
            ),

            BlocProvider(create: (context) => ProductDetailsCubit(),)
          ],
          child: BlocConsumer<ShopCubit,ShopStates>(
            listener: (context, state)
            {

            },
            builder: (context, state) => MaterialApp(

              debugShowCheckedModeBanner: false,

              home: Directionality(
                child: Screen,
                textDirection: ShopCubit.get(context).isEnglish ? TextDirection.ltr : TextDirection.rtl,
              ),

              theme: lightTheme,

              darkTheme: darkTheme,

              themeMode: ShopCubit.get(context).isDarkMode ? ThemeMode.dark : ThemeMode.light,



            ),
          )
        );

  }
}