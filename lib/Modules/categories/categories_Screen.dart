import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Models/categories_Model.dart';
import 'package:shopapp/Modules/categories_Details/categories_Details_Screen.dart';
import 'package:shopapp/Styles/colors.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/cubit/cubit.dart';
import 'package:shopapp/cubit/states.dart';

class Categories_Screen extends StatelessWidget
{
  const Categories_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var cubit = ShopCubit.get(context);

        return cubit.categoryModel == null
            ?
        Center(child: CircularProgressIndicator())
            :
          ListView.separated(
            separatorBuilder: (context, index) => myDivider(),
            itemBuilder: (context, index) => buildCatItem(cubit.categoryModel!.data!.data[index],context),
            itemCount: cubit.categoryModel!.data!.data.length,
        );

      },

    );
  }

  Widget buildCatItem(CategoriesData model , context) => InkWell(
    onTap: ()
    {
      ShopCubit.get(context).getCategoriesDetailsData(model.ID!);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) 
      {
        return Categories_Details_Screen(model.Name!,model.ID!);
      })).then((value) 
      {
        ShopCubit.get(context).categoryDetailsModel = null;
      });
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:
        [
          Image(image: CachedNetworkImageProvider('${model.Image}',),
            width: 80.0,
            height: 80.0,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 20.0,),
          Expanded(
            child: Text('${model.Name}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
                  , color: fontColor(context)
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          //Spacer(),
          Icon(Icons.arrow_forward_ios ,  color: fontColor(context))
        ],
      ),
    ),
  );


}
