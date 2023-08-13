
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do/shared/components/components.dart';
import 'package:intl/intl.dart';
import 'package:to_do/shared/components/constants.dart';
import 'package:to_do/shared/cubit/states.dart';

import '../shared/cubit/cubit.dart';


class HomeLayout extends StatelessWidget
{

  Database? database;
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  var titleController=TextEditingController();
  var timingController=TextEditingController();
  var dateController=TextEditingController();


  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (BuildContext context)=> AppCubit()..createDatabase(),

    child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, AppStates state) {  },

        builder: (BuildContext context, state) {
          AppCubit cubit=AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[ AppCubit.get(context).currentIndex],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(AppCubit.get(context).isBottomSheetShown){

                  if(formKey.currentState!.validate()){
                    AppCubit.get(context).insertToDatabase(
                      date: dateController.text,
                      time:  timingController.text,
                      title: titleController.text,
                    )?.then((value) {
                      AppCubit.get(context).changeIcon(isShow: false, icon: Icons.edit);
                      Navigator.pop(context);
                      AppCubit.get(context).refreshPage();

                    });
                    print('helpppppppp');
                  }

                }
                else {
                  AppCubit.get(context).changeIcon(isShow: true, icon: Icons.add);

                  scaffoldKey.currentState?.showBottomSheet((context) =>
                      Container(
                        color: Colors.grey[100],
                        padding: EdgeInsetsDirectional.all(20.0),
                        child: Form(
                          key: formKey,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller: titleController,
                                prefixIcon: Icons.title,
                                labelText: 'Task Title',
                                validation: true,
                                keyBoardType: TextInputType.text,
                                alertText: 'title must not be empty',
                              ),
                              SizedBox(height: 20,),
                              defaultFormField(
                                onTap: (){

                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now()
                                  ).then((value) => {
                                    timingController.text=value!.format(context).toString(),
                                  });
                                },
                                controller: timingController,
                                prefixIcon: Icons.watch_later_outlined,
                                labelText: 'Task Time',
                                validation: true,
                                keyBoardType: TextInputType.datetime,
                                alertText: 'time must not be empty',
                              ),
                              SizedBox(height: 20,),
                              defaultFormField(
                                onTap: (){

                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2023-08-01')).then((value) => {
                                    dateController.text=DateFormat.yMMMd().format(value!),
                                  });
                                },
                                controller: dateController,
                                prefixIcon: Icons.watch_later_outlined,
                                labelText: 'Task Date',
                                validation: true,
                                keyBoardType: TextInputType.datetime,
                                alertText: 'Date must not be empty',
                              ),

                            ],
                          ),
                        ),
                      ),
                  ).closed.then((value)=>{
                    AppCubit.get(context).changeIcon(isShow: false, icon: Icons.edit),
                  }
                  );


                }
              },
              child: Icon( AppCubit.get(context).fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex:AppCubit.get(context).currentIndex,
              onTap: (index){
                AppCubit.get(context).changeIndex(index);
              },

              items:
              [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',

                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',

                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',

                ),
              ],
            ) ,
            body:state is AppGetDatabaseLoadingState? Center(child: CircularProgressIndicator(
              color: Colors.red,
              strokeWidth: 90,
            )): AppCubit.get(context).screens[ AppCubit.get(context).currentIndex],
          );
        }
      ),
    );
  }



}

