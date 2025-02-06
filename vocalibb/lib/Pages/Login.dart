import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vocalibb/Pages/MainPage.dart';
import 'package:vocalibb/Pages/SelectGenre.dart';

import 'globals.dart';
class LoginPage extends StatefulWidget {
   LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   final TextEditingController _usercontroller=TextEditingController();

   final TextEditingController _passcontroller=TextEditingController();
   //bool islogged=false;

  Future<void> authenticateuser(String username,String password,BuildContext context) async{
    print("http://"+ip+":8080/finalproject/login.php");
    
    final response= await http.post(
      Uri.parse("http://"+ip+":8080/finalproject/login.php"),
      body: {
        "username":username,
        "password":password
      }
    );

    print(response.body);
    if(response.statusCode==200){
      
      final responseData= json.decode(response.body);
      if(responseData["status"]=="success"){
        
        SharedPreferences prefs=await SharedPreferences.getInstance();
        prefs.setString("id",responseData["id"]);
        print(responseData["name"]);
        prefs.setString("name",responseData["name"]);
        print("ispreffff");
        if(responseData["isprefset"]=="0"){
          Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=> SelectGenre() ));
        }
        else{
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=> MainPage() ));
        }
      }
      else{
        print(responseData["message"]);
      }
    }
    else{
      print("Failed to authenticate");
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color(0xFFF1F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 130),
                  child: Text(
                    "Welcome to",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    "Fr Francis Sales Libray",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 90),
                  child: Container(
                    height:55,
                    width: 300,
                    child: TextField(
                      controller: _usercontroller,
                      decoration: InputDecoration(
                        filled:true ,
                        fillColor: Color(0xFFFFFFFF),
                          labelText: "Username",
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
                      controller: _passcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled:true ,
                        fillColor: Color(0xFFFFFFFF),
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:23),
                  child: Container(
                    width: 100,
                    child: TextButton(
                      onPressed: () {
                        print('TextButton Pressed!');
                        authenticateuser(_usercontroller.text, _passcontroller.text,context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF14181B),
                        backgroundColor: Color(0xffC5DEDB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top:23),
                //   child: Text("Forgot Password?",
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}