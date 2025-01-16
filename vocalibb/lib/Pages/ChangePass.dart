import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalibb/Pages/globals.dart';
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentpass=TextEditingController();
  TextEditingController newpass=TextEditingController();
  TextEditingController confirmpass=TextEditingController();
  
  String id="";
  Future<void> changepass(String id,String newpass,String currentpass) async{
    final response = await http.post(
        Uri.parse("http://" + ip + ":8080/finalproject/changepass.php"),
        body: {
          "id": id,
          "current":currentpass,
          "new":newpass
        });
    if(response.statusCode==200){
      print(response.body);
      final messagebody=json.decode(response.body);
      if(messagebody["message"]=="Successfull"){
        print("ho");
        Fluttertoast.showToast(
                        msg: "Password Changed Successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: const Color(0xffC5DEDB),
                        textColor: const Color(0xFF14181B),
                        fontSize: 16.0
                    );
      }
      else if(messagebody["message"]=="Current Password Wrong"){
        Fluttertoast.showToast(
                        msg: "Current Password Invalid",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: const Color(0xffC5DEDB),
                        textColor: const Color(0xFF14181B),
                        fontSize: 16.0
                    );
      }
    }
  }
  Future<void> getid()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    id=prefs.getString("id")?? "";
    print(id);
  }
  @override
  void initState()  {
    super.initState();
    getid();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10,top: 20),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back,size: 30,)),
                  ),
                  
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10,top: 50),
                    child: Text("Change Password",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600),),),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Container(
                      height: 55,
                      width: 300,
                      child: TextField(
                        controller: currentpass,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled:true ,
                          fillColor: Color(0xFFFFFFFF),
                            labelText: "Current Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 23),
                    child: Container(
                      height: 55,
                      width: 300,
                      child: TextField(
                        controller: newpass,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled:true ,
                          fillColor: Color(0xFFFFFFFF),
                            labelText: "New Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 23),
                    child: Container(
                      height: 55,
                      width: 300,
                      child: TextField(
                        controller: confirmpass,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled:true ,
                          fillColor: Color(0xFFFFFFFF),
                            labelText: "Confirm Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                  ),
                   Padding(
                padding: const EdgeInsets.only(top:20),
                child: Container(
                  width: 120,
                  height: 50,
                  child: TextButton(onPressed: (){
                       if(newpass.text==confirmpass.text){
                        print("Sameee");
                        changepass(id,newpass.text,currentpass.text);
                       }
                       else{
                        print("else");
                        Fluttertoast.showToast(
                        msg: "Password do not match",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue[200],
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                       } 
                  },
                  style: TextButton.styleFrom(
                              foregroundColor:const Color(0xFF14181B),
                              backgroundColor:const Color(0xffC5DEDB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                              )
                  ),
                  child: const Text("Submit",
                  style: TextStyle(
                    fontSize: 16
                  ),),
                  ),
                ),
              )
              ],
            ),
          ),
        )),);
  }
}