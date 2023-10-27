import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Modules/contactUs/contactUsScreen.dart';
import 'package:shopapp/Modules/profileSettings/profile_Settings_Screen.dart';
import 'package:shopapp/Styles/appLanguage.dart';
import 'package:shopapp/Styles/colors.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/components/constants.dart';
import 'package:shopapp/cubit/cubit.dart';
import 'package:shopapp/cubit/states.dart';

class Settings_Screen extends StatelessWidget
{

  List<String> langEN = ['English' , 'Arabic'];
  List<String> langAR = [ 'العربية','الأنجليزية'];

  @override
  Widget build(BuildContext context)
  {

    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context, state)
      {},
      builder: (context, state)
      {


        var cubit = ShopCubit.get(context);

        List<String> lang = [];

        if(cubit.isEnglish)
        {
          lang = langEN;
        }
        else
        {
          lang = langAR;
        }


        return
          SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children:
              [
               Center(child: Text(langSettings(context) , style: TextStyle(fontSize: 40.0,color: fontColor(context))),),
                SizedBox(height: 50.0,),

                Row(
                  children:
                  [
                    Text(langDarkMode(context) , style: TextStyle(fontSize: 25.0,color: fontColor(context)),),
                    Expanded(
                      child: Center(
                        child: Switch(

                            value: cubit.isDarkMode,
                            onChanged: (val)
                            {
                              cubit.changeDarkMode();
                            }
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.0,),

                Row(
                  children:
                  [
                    Text(langLanguage(context) , style: TextStyle(fontSize: 25.0,color: fontColor(context)),),
                    Expanded(
                      child: Center(
                        child: DropdownButton(
                          value:  lang[0] ,
                          onChanged: (val)
                          {
                            if(val == 'Arabic')
                            {
                              if(cubit.isEnglish)
                              {
                                cubit.changeLang();
                              }
                            }
                            else
                            {
                              if(!cubit.isEnglish && val == 'الأنجليزية')
                              {
                                cubit.changeLang();
                              }
                            }
                          },
                          items:
                          [
                            DropdownMenuItem(child: Text(lang[0]),value: lang[0],),
                            DropdownMenuItem(child: Text(lang[1]) , value: lang[1],),
                          ],
                          style: TextStyle(fontSize: 17.0,color: fontColor(context)),
                          dropdownColor: cubit.isDarkMode ? darkColor : Colors.white,
                          iconEnabledColor: DefaultColor,
                          borderRadius: BorderRadius.circular(15.0),


                        )
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.0,),


                myButton(
                    text: langEditProfile(context),
                    function: ()
                    {
                      navTo(context, Profile_Settings_Screen());
                    }),
                SizedBox(height: 20.0,),

                myButton(
                    text: langAboutDeveloper(context),
                    function: ()
                    {
                      navTo(context, Contact_Us_Screen());
                    }),
                SizedBox(height: 20.0,),

                myButton(
                    text: langLogOut(context),
                    function: ()
                {
                  signOut(context);
                }),



              ],
            ),
        ),
          );
      },
    );
  }
}
