import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:shopapp/Models/favorites_Model.dart';
import 'package:shopapp/Styles/colors.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/cubit/cubit.dart';
import 'package:shopapp/cubit/states.dart';

class Categories_Details_Screen extends StatelessWidget
{
  String name;
  int ID;

  Categories_Details_Screen(this.name,this.ID);

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context, state)
      {
        if(state is ShopErrorCategoriesDetailsDataState)
        {
          myDialog(context,()
          {
            ShopCubit.get(context).getCategoriesDetailsData(ID);
            Navigator.of(context).pop();
          });
        }
      },
      builder: (context, state)
      {
        var cubit = ShopCubit.get(context);

        return Directionality(
            textDirection: cubit.isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text(name),
            ),
            body: cubit.categoryDetailsModel == null
                ?
            Center(child: CircularProgressIndicator())
                :
            ListView.separated(
              separatorBuilder: (context, index) => myDivider(),
              itemBuilder: (context, index) => buildProductItem(cubit.categoryDetailsModel!.data.data[index], context),
              itemCount: cubit.categoryDetailsModel!.data.data.length,
            ),
          ),
        );

      },

    );

  }



}
