import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';

import '../../shared/components/components.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var newTasks=AppCubit.get(context).doneTasks;

        AppCubit cubit=AppCubit.get(context);
        return newTasks.length>0?ListView.separated(
          itemBuilder: (context, index) => taskBuildItem(
            firstIcon: null,
            status: newTasks![index]['status'] ,
            index: index,
            title: newTasks![index]['title'],
            time: newTasks![index]['time'],
            date: newTasks![index]['date'],
            id: newTasks![index]['id'],
            context: context,
            functionForDoneIcon:(){
              print('${index}');
            },
            functionForArchivedIcon: (){
              cubit.archivedTasks.add(newTasks[index]);

              cubit.updateData(status: 'archived', id: newTasks[index]['id']);

              cubit.doneTasks.removeAt(index);
            },
          ),

          separatorBuilder: (context, index) => SizedBox(height: 20.0,),
          itemCount: AppCubit.get(context).doneTasks.length,):defaultNODataTheme();
      },
    );

  }
}
