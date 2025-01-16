import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vocalibb/Pages/BookResult.dart';
import 'package:vocalibb/Pages/globals.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchbook=TextEditingController();
  List<dynamic> bookresults=[];
Future<void> searchBookInfo(String book) async{
  if(book==""){
    setState(() {
      bookresults=[];
    });
    
    return;
  }
  print(book);
  print("http://"+ ip +":8080/finalproject/search.php");
  final response= await http.post(
      Uri.parse("http://"+ ip +":8080/finalproject/search.php"),
      body: {
        "search":book
      }
    
    );
  print(response.body);
  if(response.statusCode==200){
    final responseData= json.decode(response.body);
    setState(() {
      bookresults=responseData;
    });
    print(bookresults[0]["title"]);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 7,right: 7,top: 12),
              child: TextField(
                controller: searchbook,
                onChanged: (value){
              
                  searchBookInfo(searchbook.text);
                  
                },
                decoration: InputDecoration(
                  filled:true,
                  fillColor: Color(0xFFFFFFFF),
                  prefixIcon: new Icon(Icons.search,
                    color: Color(0xff2A2E34),),
                  suffixIcon: IconButton(onPressed: (){
                    searchbook.clear();
                  }, 
                    icon: Icon(Icons.clear,
                    color: Color(0xff2A2E34))),
                    
                  labelText: "Search here",
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide:  BorderSide(
                      color: Colors.grey
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xff2A2E34))
                  )
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: bookresults.length,
                itemBuilder: (context,index){
                  String title=bookresults[index]["title"] ?? "";
                  String author=bookresults[index]["author"] ?? "";
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                      context,
                        MaterialPageRoute(
                          builder: (context) => BookInfo(book: bookresults[index],),
                      ),
                      );
                    },
                    child: ListTile(
                      
                      title: Text(title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),),
                      subtitle: Text(author,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),),
                      visualDensity: VisualDensity.compact,
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
        )
        ),
    );
  }
}