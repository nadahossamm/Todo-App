import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled2/Modules/Archivetasks/Archive.dart';
import 'package:untitled2/Modules/Donetasks/Done.dart';
import 'package:untitled2/Modules/Newtasks/NewTasks.dart';
import 'package:untitled2/Shared/Cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialSates());
  static AppCubit get(context)=> BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  late Database database;
  List <Map>? newTasks;
  List <Map>? doneTasks;
  List <Map>? archivedTasks;
  IconData iconEdit = Icons.edit;
  bool isButtonSheet = false;
  List<String> title = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];
  void changeIndex(int index)
  {
    currentIndex=index;
    emit(AppChangeBottumNavBarState());

  }
  void createDatabase() {
    openDatabase('todo.db', version: 1,
        onCreate: (Database database, int version) {
          print('Create database');
          database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
          );
        },
        onOpen: (database) {
           getFromDatabase(database);
         print('open database');
        }).then((value) {
          database=value;
          emit(AppCreateDatabaseState());
      print("Table created");
    }).catchError((error) {
      print("Error in creation of database" + error.toString());
    });
  }
 Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction ((txn)  async {
      txn .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      ) .then((value)
      {
        print("$value inserted successfully");
        emit(AppInsertToDatabaseState());
        getFromDatabase(database);
      }).catchError((error) {
        print("Error When Inserting New Data ${error.toString()}");
      });
    }
    );
  }

  void getFromDatabase(database)
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
      database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element){
        if(element['status']=="new")
          newTasks!.add(element);

        if(element['status']=="done")
          doneTasks!.add(element);

        if(element['status']=="archive")
          archivedTasks!.add(element);

      });

      emit(AppGetDatabaseState());
    });
    //  print(tasks);
  }

  void changeButtomSheetState({
   required bool isShow,
    required IconData icon,
  })
  {
      isButtonSheet=isShow;
      iconEdit=icon;
      emit(AppChangeButtonSheetState());

  }
  Future updateDatabase(
  {
  required String status,
  required int id
}
      )
   async {
      database.rawUpdate(
        'UPDATE tasks SET status=? Where id=?',
        ['$status',id]
      ).then((value){
        getFromDatabase(database);
          emit(AppUpdateDatabaseState());
      });
  }
  void deleteFromDatabase({
  required int id,
})async
  {
    database.rawDelete('DELETE FROM tasks WHERE id=?',[id])
    .then((value){
      getFromDatabase(database);
      print("DELETEDDDDDDDD");
      emit(AppDeleteDatabaseState());

  });
  }

}