import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:shopapp/Models/search_Model.dart';
import 'package:shopapp/Modules/search/cubit/cubit.dart';
import 'package:shopapp/Modules/search/cubit/states.dart';
import 'package:shopapp/Styles/appLanguage.dart';
import 'package:shopapp/Styles/colors.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/cubit/cubit.dart';

class Search_Screen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state)
        {
          if(state is SearchErrorState)
          {
            myDialog(context, ()
            {
              SearchCubit.get(context).search(searchController.text, context);
              Navigator.of(context).pop();
            });
          }
        },
        builder: (context, state)
        {

          var cubit = SearchCubit.get(context);

          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children:
                  [
                    myTextFormField(
                        context: context,
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        labelText: langSearch(context),
                        prefixIcon: Icon(Icons.search),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Search Must Not Be Empty !';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value)
                        {
                          cubit.search(value,context);
                        }
                    ),
                    SizedBox(height: 10.0,),
                    if(state is SearchLoadingState)
                      LinearProgressIndicator(),



                    SizedBox(height: 20.0,),

                    state is! SearchSuccessState || searchController.text.isEmpty
                        ?
                        Expanded(child: Center(child: Text('No Data Here ...'),))

                        :

                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => myDivider(),
                        itemBuilder: (context, index) =>
                            buildProductItem(cubit.model!.data.data[index], context , isSearch: true),
                        itemCount: cubit.model!.data.data.length,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
