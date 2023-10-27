import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Styles/appLanguage.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/components/constants.dart';
import 'package:shopapp/cubit/cubit.dart';
import 'package:shopapp/cubit/states.dart';

class Profile_Settings_Screen extends StatelessWidget
{


  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context)
  {

    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context, state)
      {
        if(state is ShopSuccessUpdateUserDataState)
        {
          if(state.user_Model.status)
          {
            myToast(msg: state.user_Model.message!, state: ToastStates.SUCCESS);

          }
          else
          {
            myToast(msg: state.user_Model.message!, state: ToastStates.ERROR);

          }
        }
        else if(state is ShopErrorUpdateUserDataState)
        {
          myToast(msg: langConnectionError(context),state: ToastStates.ERROR ,);
        }
      },
      builder: (context, state)
      {


        var cubit = ShopCubit.get(context);

        if(cubit.user_model != null)
        {
          nameController.text = cubit.user_model!.data!.name!;
          emailController.text = cubit.user_model!.data!.email!;
          phoneController.text = cubit.user_model!.data!.phone!;
        }


        return Scaffold(
          appBar: AppBar(),
          body:  cubit.user_model == null
              ?
          Center(child: CircularProgressIndicator())
              :
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children:
                  [
                    if(state is ShopLoadingUpdateUserDataState)
                      LinearProgressIndicator(),
                    SizedBox(height: 20.0,),
                    myTextFormField(
                      context: context,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      labelText: langUserName(context),
                      prefixIcon: Icon(Icons.person),
                      validator: (String? value)
                      {
                        if(value!.isEmpty)
                        {
                          return langEnterYourUserName(context);
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 20.0,),

                    myTextFormField(
                      context: context,

                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      labelText: langPhone(context),
                      prefixIcon: Icon(Icons.phone),
                      validator: (String? value)
                      {
                        if(value!.isEmpty)
                        {
                          return langEnterYourPhone(context);
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 20.0,),

                    myTextFormField(
                      context: context,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      labelText: langEmailAddress(context),
                      prefixIcon: Icon(Icons.email),
                      validator: (String? value)
                      {
                        if(value!.isEmpty)
                        {
                          return langEnterYourEmailAddress(context);
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 20.0,),

                    myTextFormField(
                      context: context,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      labelText: langPassword(context),
                      prefixIcon: Icon(Icons.lock),
                      validator: (String? value)
                      {
                        if(value!.isEmpty)
                        {
                          return langEnterYourPassword(context);
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 20.0,),

                    myButton(
                        text: langUpdate(context),
                        function: ()
                        {
                          if(formKey.currentState!.validate())
                          {
                            cubit.updateUserData(name: nameController.text, email: emailController.text, phone: phoneController.text, password: passwordController.text);
                          }
                        }),

                    SizedBox(height: 20.0,),



                  ],
                ),
              ),
            ),
          ),
        );

      },
    );
  }
}
