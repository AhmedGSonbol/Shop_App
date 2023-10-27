import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopapp/Modules/home/shopLayout.dart';
import 'package:shopapp/Modules/login/cubit/cubit.dart';
import 'package:shopapp/Modules/login/cubit/states.dart';
import 'package:shopapp/Modules/register/registerScreen.dart';
import 'package:shopapp/Network/Local/Cach_Helper.dart';
import 'package:shopapp/Styles/appLanguage.dart';
import 'package:shopapp/Styles/colors.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/components/constants.dart';
import 'package:shopapp/cubit/cubit.dart';

class ShopLoginScreen extends StatelessWidget
{

  var emailController =TextEditingController();

  var passwordController =TextEditingController();

  var formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit , ShopLoginStates>(
        listener: (context, state)
        {
          if(state is ShopLoginSuccessState)
          {
            if(state.model.status)
            {
             myToast(msg: state.model.message!, state: ToastStates.SUCCESS);

             CachHelper.saveData(key: 'token', value: state.model.data!.token).then((value)
             {
               token = state.model.data!.token!;

               ShopCubit.get(context).refresh();
               navAndFinishTo(context, ShopLayout());
             });

            }
            else
            {
              myToast(msg: state.model.message!, state: ToastStates.ERROR);

            }



          }
          else if(state is ShopLoginErrorState)
          {

             myToast(msg: langConnectionError(context),state: ToastStates.ERROR ,);
          }
        },
        builder: (context, state)
        {
          var cubit = ShopLoginCubit.get(context);

          return Directionality(
            textDirection: ShopCubit.get(context).isEnglish ? TextDirection.ltr : TextDirection.rtl,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0,top: 50.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Image(image: AssetImage('assets/images/shopping.png')),
                        SizedBox(height: 15.0,),
                        Text(langLogIn(context),
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: fontColor(context)
                          ),),

                        Text(langLoginNowToBrowseOurHotOffers(context),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.grey
                          ),),

                        SizedBox(height: 30,),


                        myTextFormField(
                            context: context,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            labelText: langEmailAddress(context),
                            prefixIcon: Icon(Icons.email_outlined),
                            validator: (String? val)
                            {
                              if(val!.isEmpty)
                              {
                                return langEnterYourEmailAddress(context);
                              }

                            }
                        ),
                        SizedBox(height: 15.0),
                        myTextFormField(
                            context: context,
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            labelText: langPassword(context),
                            isPassword: cubit.isSecure,
                            onFieldSubmitted: (val)
                            {
                              if(formKey.currentState!.validate())
                              {
                                cubit.userLogin(context,Email: emailController.text, Password: passwordController.text);
                              }
                            },
                            prefixIcon: Icon(Icons.lock_outline),
                            // suffixIcon: Icon(Icons.visibility),
                            // SuffixOnPressed: (){},
                            suffixButtonIcon: IconButton(
                                icon: Icon(cubit.passIcon),
                            onPressed: ()
                            {
                              cubit.changePassVisibility();
                            }
                            ),
                            validator: (String? val)
                            {
                              if(val!.isEmpty)
                              {
                                return langEnterYourPassword(context);
                              }
                            }
                        ),
                        SizedBox(height: 15.0),

                        state is! ShopLoginLoadingState
                        ?
                        myButton(text: langLogIn(context), function: ()
                        {
                          if(formKey.currentState!.validate())
                          {
                            ShopLoginCubit.get(context).userLogin(context,Email: emailController.text, Password: passwordController.text);
                          }

                        })
                        :
                            Center(
                              child: CircularProgressIndicator(),
                            ),

                        SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            Text(langDontHaveAnAccount(context),style: TextStyle(color: fontColor(context)),),
                            myTextButton(text: langRegister(context), function: ()
                            {
                              navTo(context, ShopRegisterScreen());
                            })

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
