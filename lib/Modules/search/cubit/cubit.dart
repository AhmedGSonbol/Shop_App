
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Models/search_Model.dart';
import 'package:shopapp/Modules/search/cubit/states.dart';
import 'package:shopapp/Network/Remote/dio_Helper.dart';
import 'package:shopapp/Network/end_points.dart';
import 'package:shopapp/components/constants.dart';
import 'package:shopapp/cubit/cubit.dart';

class SearchCubit extends Cubit<SearchStates>
{
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);



  Search_Model? model;

  void search(String text , context)
  {

    if(text.isEmpty)
    {
      emit(SearchIsEmptyState());

    }else
    {


      emit(SearchLoadingState());

      DioHelper.postData(
          token: token,
          url: SEARCH,
          lang: ShopCubit.get(context).getDioLang(),
          data: {'text' : text}
      )!.then((value)
      {
        model = Search_Model.fromJson(value.data);

        emit(SearchSuccessState());

      }).catchError((err)
      {

        emit(SearchErrorState());

      });
    }


  }
}