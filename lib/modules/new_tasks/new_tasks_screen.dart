import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/components/components.dart';
import 'package:to_do/shared/components/constants.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {

      NewTasksScreen(
       {Key? key}
       ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit=AppCubit.get(context);
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {
        AppCubit.get(context);
        },
      builder: ( context,state) {
        var newTasks=AppCubit.get(context).newTasks;
        print('the new tasks is : $newTasks');
        return newTasks.length>0?ListView.separated(
          itemBuilder: (context, index) => taskBuildItem(
            title: newTasks![index]['title'],
            time: newTasks![index]['time'],
            date: newTasks![index]['date'],
            id: newTasks![index]['id'],
            status: newTasks![index]['status'] ,
            index: index,
            context: context,
            functionForDoneIcon:(){
              print('${index}');

              cubit.doneTasks.add(newTasks[index]);


              print(newTasks);
              cubit.updateData(status: 'done', id: newTasks![index]['id']);

              cubit.newTasks.removeAt(index);


            },
            functionForArchivedIcon: (){

              cubit.archivedTasks.add(newTasks[index]);

              cubit.updateData(status: 'archived', id: newTasks[index]['id']);

              cubit.newTasks.removeAt(index);

            },
          ),

          separatorBuilder: (context, index) => SizedBox(height: 20.0,),
          itemCount: AppCubit.get(context).newTasks.length,): defaultNODataTheme();
      }
    );

  }
}
