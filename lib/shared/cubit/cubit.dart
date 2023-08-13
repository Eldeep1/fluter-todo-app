import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';
import '../components/constants.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super (AppInitialState());

  BuildContext? get context => null;
  static AppCubit get(context)=>BlocProvider.of(context);
  int currentIndex=0;
  List<Widget> screens=[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles=[
    'Tasks',
    'Done',
    'Archived',
  ];

 late Database database;

  List<Map> tasks=[];
  List<Map> doneTasks=[];
  List<Map> newTasks=[];
  List<Map> archivedTasks=[];

  IconData fabIcon=Icons.edit;

  int tasksLength=0;
  bool firstTimeClassify=true;
  void refreshPage(){
    emit(AppRefreshBodyState());
  }
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBareState());
  }

  void createDatabase()
  {

     openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version){
          print('database created');
          database.execute('CREATE TABLE tasks ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'title TEXT,'
              'date TEXT,'
              'time TEXT,'
              'status TEXT'
              ')').then((value) => (){})
              .catchError((onError){
            print('the error you encountered is : ${onError.toString()}');
          });
        },
        onOpen: (database){
          // database.rawQuery('create table tasks ('
          //     'id int auto_increment,'
          //     ' title text ,'
          //     ' date text , '
          //     'time text , '
          //     'status text,'
          //     'primary key (id)'
          //     ')').then((value) => print(value.toString()));
          getDataFromDatabase(database).then((value) {
            tasks=value;
            tasksLength=tasks.length;
            classifyStatus();
            firstTimeClassify=false;
            print('the current values is : $tasks');
            emit(AppGetDatabaseState());
          });
          print('database opened');
        }
    ).then((value)  {
      database=value;
      print('after creating database value is : $value');
    emit(AppCreateDatabaseState());
    });


  }

  Future<List<Map>> getDataFromDatabase(database)async{

    emit(AppGetDatabaseLoadingState());

    return await database?.rawQuery('select * from tasks');
  }



  Future? insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async
  {
    return await database?.transaction((txn) => txn.rawInsert(
        'insert into tasks(title,date,time,status) values("$title","$date","$time","new")'
    ).then((value)  {
      print('helppp inside the insert method');
      print('$value inserted successfully');
       getDataFromDatabase(database).then((value)  {
        tasks=value;

        classifyStatus();

        emit(AppGetDatabaseState());

      });
       emit(AppInsertDatabaseState());
    }).catchError((onError){
      print('the error we got while inserting is : ${onError.toString()}');
    }));
  }

  void changeIcon({
  @required bool? isShow,
  @required IconData? icon,
}){
    isBottomSheetShown=isShow!;
    fabIcon=icon!;
    emit(AppChangeIconState());

  }

  bool isBottomSheetShown=false;

  void  updateData({
  required String status,
  required int id,

}) async{
    await database.rawUpdate(
      'update tasks set status = "$status" where id=$id',
    ).then((value) {
      print('$id and the new status is : $status');
      print('raw updated successfully $value');
      emit(AppUpdateDatabaseState());
     }).catchError((onError){
       print('the error we got while updating is : $onError');
     });

  }


  void  deleteData({
  required int id,
  required String status,
  required int index,

}) async{
    await database.rawDelete(
      'delete from tasks where id=?',[id],
    ).then((value) {
      if(status=='done'){
        doneTasks.removeAt(index);
      }else if(status=='new'){
        newTasks.removeAt(index);
      }if(status=='archived'){
        archivedTasks.removeAt(index);
      }
      print('raw deleted successfully $value');
      emit(AppDeleteDatabaseState());
     }).catchError((onError){
       print('the error we got while deleting is : $onError');
     });

  }


  void classifyStatus(){
   if(tasksLength!=tasks.length&&firstTimeClassify==false){
     if(tasks[tasks.length-1]['status']=='new'){
       newTasks.add(tasks[tasks.length-1]);
     }else if(tasks[tasks.length-1]['status']=='done'){
       doneTasks.add(tasks[tasks.length-1]);
     }if(tasks[tasks.length-1]['status']=='archived'){
       archivedTasks.add(tasks[tasks.length-1]);
     }
   }
   else {
     for (var element in tasks) {
       if (element ['status'] == 'new') {
         newTasks.add(element);
       } else if (element ['status'] == 'done') {
         doneTasks.add(element);
       } else if (element ['status'] == 'archived') {
         archivedTasks.add(element);
       }
     }
     emit(AppUpdateDatabaseState());
   }
  }


}