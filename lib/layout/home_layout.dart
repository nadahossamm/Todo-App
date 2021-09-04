import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/Shared/Components/components.dart';
import 'package:untitled2/Shared/Constants.dart';
import 'package:untitled2/Shared/Cubit/cubit.dart';
import 'package:untitled2/Shared/Cubit/states.dart';

class HomeLayout extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context )=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates states){
          if (states is AppInsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context,AppStates states){
          return Scaffold(
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
              child: Icon(AppCubit.get(context).iconEdit),
              onPressed: () {
                if (AppCubit.get(context).isButtonSheet) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).insertToDatabase(title: titleController.text, time: timeController.text, date: dateController.text);
                    Navigator.pop(context);
                    AppCubit.get(context).changeButtomSheetState(isShow: false, icon: Icons.edit);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) {
                      return Container(
                        //height: heightResponsive(context: context, height: 5),
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: formKey,
                          child:
                          Column(mainAxisSize: MainAxisSize.min, children: [
                            defaultTextFormField(
                              icons: Icon(Icons.title),
                              height: 10,
                              borderColor: Colors.black26,
                              controller: titleController,
                              context: context,
                              label: 'Task Title',
                              type: TextInputType.text,
                              messageValidate: 'Title must not be empty',
                            ),
                            SizedBox(
                              height: heightResponsive(
                                height: 50,
                                context: context,
                              ),
                              width: double.infinity,
                            ),
                            defaultTextFormField(
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value) => timeController.text =
                                    value!.format(context).toString());
                              },
                              icons: Icon(Icons.access_time),
                              height: 10,
                              borderColor: Colors.black26,
                              controller: timeController,
                              context: context,
                              label: 'Task Time',
                              type: TextInputType.datetime,
                              messageValidate: 'Time must not be empty',
                            ),
                            SizedBox(
                              height: heightResponsive(
                                height: 50,
                                context: context,
                              ),
                              width: double.infinity,
                            ),
                            defaultTextFormField(
                              onTap: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2070-12-30'))
                                    .then((value) => dateController.text =
                                    DateFormat.yMMMd().format(value!));
                              },
                              icons: Icon(Icons.calendar_today),
                              height: 10,
                              borderColor: Colors.black26,
                              controller: dateController,
                              context: context,
                              label: 'Task Date',
                              type: TextInputType.datetime,
                              messageValidate: 'Date must not be empty',
                            ),
                          ]),
                        ),
                      );
                    },
                    elevation: 25.0,
                  ) .closed
                      .then((value) {
                    AppCubit.get(context).changeButtomSheetState(isShow: false, icon: Icons.edit);
                  });
                  AppCubit.get(context).changeButtomSheetState(isShow: true, icon: Icons.add);

                }
              },
            ),
            appBar: AppBar(
              title: Text(AppCubit.get(context).title[AppCubit.get(context).currentIndex]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex:AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(icon: Icon(Icons.check_box), label: "Done"),
                BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archive"),
              ],
            ),
            // body:tasks!.length==0?CircularProgressIndicator():screens[currentIndex],
            body:states is! AppGetDatabaseLoadingState
                ? AppCubit.get(context).screens[AppCubit.get(context).currentIndex]
                : Center(child: CircularProgressIndicator()),

          );
        },

      ),
    );
  }


}
