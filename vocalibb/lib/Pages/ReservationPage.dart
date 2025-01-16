import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vocalibb/Pages/globals.dart';
class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}
String id="";
List<dynamic> reservationlist=[];
class _ReservationPageState extends State<ReservationPage> {
  Future<void> getid()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    id=prefs.getString("id")?? "";
    print(id);
  }
  Future<void> getreservation(String id) async{
    final response = await http.post(
        Uri.parse("http://" + ip + ":8080/finalproject/getreservation.php"),
        body: {
          "id": id,
          
        });
    print(response.body);
    if(response.statusCode==200){
      final responsedata=json.decode(response.body);
      setState(() {
        reservationlist=responsedata;
      });
    }
        
  }
  Future<void> deletereservation(String rid,String bid) async{
    final response = await http.post(
        Uri.parse("http://" + ip + ":8080/finalproject/deletereservation.php"),
        body: {
          "rid": rid,
          "bid":bid
        });
    print(response.body);
    if(response.statusCode==200){
      print(response.body);
      final responsedata=json.decode(response.body);
      if(responsedata["message"]=="Successfull"){
        print("Success");
        getreservation(id);
      }
      else if(responsedata["message"]=="Unsuccessfull"){
        print("Unsuccessfull");
      }
    }
  }
  @override
  void initState()  {
    super.initState();
    getid();
    getreservation(id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  padding: EdgeInsets.only(left: 10,top: 30),
                  child: Text("Reservation List",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600),),),
              ),
              Expanded(
            child: ListView.separated(
              itemCount: reservationlist.length,
              itemBuilder: (context,index){
                String title=reservationlist[index]["title"] ?? "";
                String edt=reservationlist[index]["edt"] ?? "";
                return Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: ListTile(
                    
                    title: Text(title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),),
                    subtitle: Text("Checkout date: $edt",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),),
                    visualDensity: VisualDensity.compact,
                    trailing: GestureDetector(
                      onTap: (){
                                    showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete'),
                                  content: const SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                            'Do you want to remove '),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        deletereservation(reservationlist[index]["rid"].toString(),reservationlist[index]["bid"].toString());
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(onPressed: (){
                                        Navigator.of(context).pop();
                                    }, child: const Text("No"))
                                  ],
                                );
                              },
  );
                      },
                      child: Icon(Icons.remove_circle_outline_outlined,
                      color: const Color.fromARGB(255, 209, 62, 52),),
                    ),
                  ),
                );
              },
              separatorBuilder: (context,index){
                return Divider(
                  color: Color(0xff2A2E34),
                  thickness: 0.7,
                );
              },
              ),
          )
            ],
          ),
        ),
      ),
    );
  }
}