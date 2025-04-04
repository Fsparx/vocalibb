import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalibb/Pages/Cart.dart';
import 'package:vocalibb/Pages/ChangePass.dart';
import 'package:vocalibb/Pages/Login.dart';
import 'package:vocalibb/Pages/ReservationPage.dart';
import 'package:vocalibb/Pages/SelectGenre.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _name = "";
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setname();
  }

  Future<void> _setname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("name").toString();
    String id = prefs.getString("id").toString();
    setState(() {
      _name = name;
    });
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F4F8),
      body: SafeArea(
        child:SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Center(
                child: CircleAvatar(
                backgroundColor: Color(0xFFF1F4F8),
                    
                  radius: 80,
                  backgroundImage: AssetImage("assets/user.png"),
                
                ),
              ),
            ),
          
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Hello! $_name",
                      style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                    )),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.only(left: 10,top: 20),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SelectGenre()));
                },
                child: Text("Change Preferences",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20
                ),),
              ),),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.only(left: 10,top: 20),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangePassword()));
                },
                child: Text("Change Password",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20
                ),),
              ),),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.only(left: 10,top: 20),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ReservationPage()));
                },
                child: Text("Reservation List",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20
                ),),
              ),),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.only(left: 10,top: 20),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CartPage()));
                },
                child: Text("Cart",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20, 
                ),),
              ),),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.only(left: 10,top: 20),
              child: GestureDetector(
                onTap: (){
                  showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Do you want to log out'),
              
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => LoginPage()),
  (Route<dynamic> route) => false, // This removes all previous pages.
);
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
                },
                child: Text("Log out",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20, 
                ),),
              ),),
            ),
          ],
          ),
        ),
        
        ),);
  }
}