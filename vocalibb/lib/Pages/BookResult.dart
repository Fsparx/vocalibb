import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vocalibb/Pages/Firstfloor.dart';
import 'package:vocalibb/Pages/Groundfloor.dart';
import 'package:vocalibb/Pages/globals.dart';
import 'package:vocalibb/Pages/map.dart';
class BookInfo extends StatefulWidget {
  final Map<String, dynamic> book;
  const BookInfo({super.key,required this.book});

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  String id="";
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
    String author=widget.book["author"];
    String isbn=widget.book["isbn"];
    String available=widget.book["available"];
    String year=widget.book["year"].toString();
    String rackid=widget.book["rackid"].toString();
    String pub=widget.book["pubdetails"];
    String link="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png";
    if(isbn!=""){
      link="https://covers.openlibrary.org/b/isbn/$isbn-L.jpg";
    }
    Future<void> addtocart(String id,String bid) async{
      final response = await http.post(
        Uri.parse("http://" + ip + ":8080/finalproject/addtocart.php"),
        body: {
          "id": id,
          "bid":bid
        });
      if(response.statusCode==200){
        final messagebody=json.decode(response.body);
        print(response.body);
      }
  }
  Future<void> reservebok(String id,String bid) async{
    final response = await http.post(
        Uri.parse("http://" + ip + ":8080/finalproject/reservebook.php"),
        body: {
          "id": id,
          "bid":bid
        });

    if(response.statusCode==200){
      print(response.body);
      print(id);
      final messagebody=json.decode(response.body);
      if(messagebody["message"]=="Successfull"){
        print(id);
        print("Success");
        showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Book Reserved'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('You have to checkout before 2 days'),
              
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
      }else if(messagebody["message"]=="NOT AVAILABLE"){
        showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Sorry'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('The book is already reserved. Do you want add to cart?'),
              
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(onPressed: (){
              addtocart(id,widget.book["bid"].toString());
              Navigator.pop(context);
          }, child: Text("Yes")),
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
      }
      else if(messagebody["message"]=="YOU RESERVED"){
        showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Note'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('You have already reserved'),
              
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
      }
    }
  }
  
    return Scaffold(
      backgroundColor: Color(0xFFF1F4F8),
      body:  SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back))),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      height: 261,
                      width: 261,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image:  DecorationImage(
                          image: NetworkImage(link),
                          fit: BoxFit.fill)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(widget.book["title"],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),),
                  ),
                  
                ),
                Padding(
                  
                  padding: EdgeInsets.all(10),
                  child: Text("Author: $author",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),),
                ),
                Padding(
                  
                  padding: EdgeInsets.all(10),
                  child: Text("Year: $year",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),),
                ),
                Padding(
                  
                  padding: EdgeInsets.all(10),
                  child: Text("Publication: $pub",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),),
                ),
                Padding(
                  
                  padding: EdgeInsets.all(10),
                  child: Text("Isbn:$isbn",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),),
                ),
                Padding(
                  
                  padding: EdgeInsets.all(10),
                  child: Text("Available: $available",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),),
                ),
                Padding(
                  
                  padding: EdgeInsets.all(10),
                  child: Text("Rack id: $rackid",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),),
                ),
              ],),
            )),
        ],
      )),
      bottomNavigationBar: Container(
        color: Color(0xFFF1F4F8),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 150,
              height: 50,
              child: TextButton(
                onPressed: () {
                  print("Button 1 clicked");
                  reservebok(id,widget.book["bid"].toString());
                },
                child: const Text('Reserve Book'),
                style: TextButton.styleFrom(
                              foregroundColor:const Color(0xFF14181B),
                              backgroundColor:const Color(0xffC5DEDB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                              )
                  ),
              ),
            ),
            Container(
              width: 150,
              height: 50,
              child: TextButton(
                onPressed: () {
                  print(rackid);
                  for (int i = 0; i < pathway.length; i++) {
                    if (pathway[i]['rackId'] == rackid) {
                      final List<Map<String, dynamic>> _directions =
                          pathway[i]['${rackid}'];
                      if (rackid == '47A' ||
                          rackid == '97A' ||
                          rackid == '100B' ||
                          rackid == '100A' ||
                          rackid == '103B' ||
                          rackid == '102B' ||
                          rackid == '103A' ||
                          rackid == '102A' ||
                          rackid == '34B' ||
                          rackid == '34A' ||
                          rackid == '96A') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FirstFloor(
                                bookId: '',
                                rackId: rackid,
                                array: _directions,
                              ),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroundFloor_Screen(
                                bookId: '',
                                rackId: rackid,
                                array: _directions,
                              ),
                            ));
                      }
                    }
                  }
                },
                child: const Text('Navigate'),
                style: TextButton.styleFrom(
                              
                              foregroundColor:const Color(0xFF14181B),
                              backgroundColor:const Color(0xffC5DEDB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                              )
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
