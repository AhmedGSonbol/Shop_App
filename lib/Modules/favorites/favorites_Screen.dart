import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:shopapp/Models/favorites_Model.dart';
import 'package:shopapp/Styles/appLanguage.dart';
import 'package:shopapp/Styles/colors.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/cubit/cubit.dart';
import 'package:shopapp/cubit/states.dart';

class Favorites_Screen extends StatelessWidget
{
  const Favorites_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var cubit = ShopCubit.get(context);

        return
          (()
          {
            print(cubit.infavourites);

               if(state is ShopErrorGetFavoritesDataState)
               {
                 return Center(
                     child: Text(langConnectionError(context))
                 );
               }
               else if(cubit.infavourites.isEmpty)
               {
                 return Center(child: CircularProgressIndicator());

               }
               else if(!cubit.infavourites.values.contains(true))
               {
                 return Center(
                     child: Text(langNoFavoritesFound(context))
                 );
               }
               else
               {
                 return
                 ListView.separated(
                   separatorBuilder: (context, index) => myDivider(),
                   itemBuilder: (context, index) => buildProductItem(cubit.favorites_model!.data.data[index].product , context),
                   itemCount: cubit.favorites_model!.data.data.length,);
               }
             // state is ShopLoadingFavoritesDataState
             //     ?
             // Center(child: CircularProgressIndicator())
             //     :
             // cubit.infavourites.isEmpty
             //     ?
             // Center(
             //     child: Text('No Fevorites Found !')
             // )
             //     :
             //
             // ListView.separated(
             //   separatorBuilder: (context, index) => myDivider(),
             //   itemBuilder: (context, index) => buildProductItem(cubit.favorites_model!.data.data[index].product , context),
             //   itemCount: cubit.favorites_model!.data.data.length,
             //);
          }
          ());


      },

    );

  }



}
