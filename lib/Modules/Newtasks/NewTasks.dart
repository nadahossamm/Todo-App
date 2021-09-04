
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/Shared/Components/components.dart';
import 'package:untitled2/Shared/Constants.dart';
import 'package:untitled2/Shared/Cubit/cubit.dart';
import 'package:untitled2/Shared/Cubit/states.dart';

class NewTasks extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return  BlocConsumer<AppCubit,AppStates>(
listener:(context,states){} ,
builder:(context,states){
  var tasks=AppCubit.get(context).newTasks;
  return  ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(context: context,model: tasks?[index]),
    itemCount: tasks?.length??0,
    separatorBuilder: (context, index) => Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    ),
  );
} ,

    );}

}
//tasks!.length==0?CircularProgressIndicator()