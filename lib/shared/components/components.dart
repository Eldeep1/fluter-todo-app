import 'package:flutter/material.dart';
import 'package:to_do/shared/cubit/cubit.dart';
Widget defaultFormField (
{

   Function(String?)? onChanged,
  required TextEditingController controller,
  bool obscureText=false,
  IconData? suffixIcon,
  // required String? Function(String?)? validate,
  required IconData? prefixIcon,
  required String labelText,
  required bool validation ,
  String? alertText='Field is required',
  var suffixClick,
  String? hitText,
  String? errorText,
  double width=double.infinity,
  TextInputType? keyBoardType,
  var onTap,
  bool isClickAble=true,
}

){
  return
  Container(
    width: width ,
    child: TextFormField(
      onTap: onTap,
          enabled: isClickAble,
          style: TextStyle(
            fontSize: 14,
          ),
              onChanged: onChanged,
          keyboardType: keyBoardType,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
              hintText:hitText ,
          errorText: errorText,
          border: OutlineInputBorder(),
          prefixIcon: Icon(prefixIcon),
          labelText: labelText,
              suffixIcon: suffixIcon !=null ? IconButton(onPressed: suffixClick, icon: Icon(suffixIcon)):null,
          ),
          validator: (value){
                if (validation){

                  if(value==null||value.isEmpty){
                    return alertText;
                  }
                  return null;
                }
          },
),
  );
}




Widget materialbutton(
{
  required String text,
  required Color buttonColor,
  double width = double.infinity,
  double height = 40.0,
  Color textColor = Colors.white,
  required Function() function,
}
){
  return Container(
    width: width,
    child: MaterialButton(
      onPressed: function,
      color: buttonColor,
      height: height,
      child: Text(
        text,
        style: TextStyle(
          color:textColor,
        ),
      ),
    ),
  );
}

Widget textbutton({
  required String text,
  required String coloredText,
Color coloredTextColor=Colors.blue,
  Color textColor=Colors.black,
  required Function() function,
}
    ){
  return Row(
    children: [
      Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
      TextButton(onPressed: function, child: Text(
        coloredText,
        style: TextStyle(
          color: coloredTextColor,
        ),
      ))
    ],
  );
}

Widget taskBuildItem({
  required String time,
  required String title,
  required String date,
  required int id,
  required String status,
  required context,
  required functionForDoneIcon,
  required functionForArchivedIcon,
  IconData? firstIcon=Icons.check_box,
  IconData? secondIcon=Icons.archive_outlined,
  required int index,

})=>Dismissible(

  key: Key('${id.toString()}_${DateTime.now().millisecondsSinceEpoch}'),
  onDismissed: (direction) {
    AppCubit.get(context).deleteData(
            id: id,
            status: status,
            index: index,

    );
  },
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40.0,

          child : Text(time),

        ),

        SizedBox(width: 20.0,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(title ,

                style: TextStyle(

                  fontSize: 20.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(date,

                style: TextStyle(

                  fontSize: 12.0,

                  color: Colors.grey,

                ),

              ),



            ],

          ),

        ),

        SizedBox(width: 20.0,),

        IconButton(onPressed: functionForDoneIcon,

          // AppCubit.get(context).

            icon: Icon(

              firstIcon,

              color: Colors.green,

            ),

        ),





        IconButton(onPressed: functionForArchivedIcon,

            icon: Icon(secondIcon,

        color: Colors.grey,

        )),

      ],

    ),

  ),
);

Widget defaultNODataTheme()=>Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        color: Colors.grey,
        Icons.menu,
        size: 100.0,
      ),
      Text(
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        'No Tasks Yet, Please Add Some Tasks',
      ),
    ],
  ),
);