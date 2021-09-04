import 'package:flutter/material.dart';
import 'package:untitled2/Shared/Cubit/cubit.dart';

double heightResponsive({
  required BuildContext context,
  required double height,
}) =>
    MediaQuery.of(context).size.height / height;

double widthResponsive({
  required BuildContext context,
  required double width,
}) =>
    MediaQuery.of(context).size.width / width;

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );

//SHOW TOAST
enum ToastStates {
  SUCCESS,
  ERROR,
  WARNING,
}

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
  }
  return color;
}

Widget defaultTextFormField({
  Icon? icons,
  Color borderColor = const Color(0xFF384A8A),
  Color focusedColor = const Color(0xFFEC7C28),
  required BuildContext context,
  double width = double.infinity,
  double height = 22.0,
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required String messageValidate,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isClickable = true,
  bool isPassword = false,
  bool readOnly = false,
}) =>
    Container(
      width: width == double.infinity
          ? double.infinity
          : widthResponsive(
              context: context,
              width: width,
            ),
      height: heightResponsive(
        context: context,
        height: height,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.zero,
      ),
      child: TextFormField(
        readOnly: readOnly,
        enabled: isClickable,
        controller: controller,
        obscureText: isPassword,
        keyboardType: type,
        style: TextStyle(
          fontFamily: "GOTHIC",
          fontSize: 17,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return messageValidate;
          }
          return null;
        },
        onFieldSubmitted: (value) {
          if (onSubmit != null) {
            onSubmit(value);
          }
        },
        onChanged: (value) {
          if (onChange != null) {
            onChange(value);
          }
        },
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        decoration: InputDecoration(
          prefixIcon: icons,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: focusedColor,
            ),
          ),
          labelText: label,
          labelStyle: TextStyle(
            color : Colors.black,
          ),
          border: OutlineInputBorder(),
        ),

      ),
    );

Widget defaultInkWellContainer({
  required context,
  required String text,
  required Color textColor,
  required Color containerColor,
  required Widget goTo,
}) =>
    InkWell(
      onTap: () {
        navigateTo(
          context,
          goTo,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            5.0,
          ),
          color: containerColor,
        ),
        height: heightResponsive(
          context: context,
          height: 8,
        ),
        width: widthResponsive(
          context: context,
          width: 3.5,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 30.0,
              fontFamily: "AquireBold",
            ),
          ),
        ),
      ),
    );

Widget defaultElevatedButton({
  required BuildContext context,
  double width = double.infinity,
  double height = 22,
  double letterSpacing = 0,
  required String buttonName,
  double fontSize = 20,
  String fontFamily = 'GOTHIC',
  Color textColor = const Color(0xFF27488C),
  Color primaryColor = const Color(0xFFEEEEEF),
  Color shadowColor = const Color(0xFFEEEEEF),
}) =>
    Container(
      width: width,
      height: heightResponsive(
        context: context,
        height: height,
      ),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          buttonName,
          style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              fontFamily: fontFamily,
              letterSpacing: letterSpacing),
        ),
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          shadowColor: shadowColor,
        ),
      ),
    );
Widget buildTaskItem (
{
  required BuildContext context,
Map? model,
}
    )
{
  return  Dismissible(
    key:Key(model?['id'].toString()??" ") ,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child:Row(
          children: [
            CircleAvatar(
              radius:40,
              child: Text('${model?['time']??" "}',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: widthResponsive(context: context, width: 30),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Text('${model?['title']??" "}',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  )),

                  Text('${model?['date']??" "}'),
                ],
              ),
            ),

            IconButton(onPressed: (){
              AppCubit.get(context).updateDatabase(status: 'done', id: model?['id']??"");
            }, icon:Icon(Icons.check_box,color: Colors.green,)),
            IconButton(onPressed: (){
              AppCubit.get(context).updateDatabase(status: 'archive', id: model?['id']??"");
            }, icon:Icon(Icons.archive,color: Colors.black54,)),

          ],
        ),
      ),
    ),
    onDismissed: (direction){
    AppCubit.get(context).deleteFromDatabase(id: model?['id']);
    },
  );
}