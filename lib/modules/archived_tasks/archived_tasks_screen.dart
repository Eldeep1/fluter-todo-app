import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';

import '../../shared/components/components.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var newTasks=AppCubit.get(context).archivedTasks;

        AppCubit cubit=AppCubit.get(context);

        return newTasks.length>0?ListView.separated(
          itemBuilder: (context, index) => taskBuildItem(
            index: index,
            status: newTasks![index]['status'] ,
            title: newTasks![index]['title'],
            time: newTasks![index]['time'],
            date: newTasks![index]['date'],
            id: newTasks![index]['id'],
            context: context,
            secondIcon: null,
            functionForDoneIcon:(){
              print('${index}');

              cubit.doneTasks.add(newTasks[index]);


              print(newTasks);
              cubit.updateData(status: 'done', id: newTasks![index]['id']);

              cubit.archivedTasks.removeAt(index);


            },
            functionForArchivedIcon: (){

            },
          ),

          separatorBuilder: (context, index) => SizedBox(height: 20.0,),
          itemCount: AppCubit.get(context).archivedTasks.length,):defaultNODataTheme();
      },

    );

  }
}
