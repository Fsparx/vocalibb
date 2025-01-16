import 'dart:convert';
import 'dart:ffi';
import 'globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalibb/Pages/MainPage.dart';
class SelectGenre extends StatefulWidget {
  const SelectGenre({super.key});

  @override
  State<SelectGenre> createState() => _SelectGenreState();
}

class _SelectGenreState extends State<SelectGenre> {
  List<String> genretodb=[];
  bool isloading=false;
  List<dynamic> genres = [ 
  ];
  String ?id;
  List<bool>? selectedGenres;
  Future<void> getadata() async{
    print("In data");
     final response= await http.post(
        Uri.parse("http://"+ip+":8080/finalproject/genredata.php")
      
    );
    //print(response.body+"hi");
    if(response.statusCode==200){
      setState(() {
      genres=json.decode(response.body);
      print(genres);
      selectedGenres =
        List<bool>.filled(genres.length, false);
      isloading=true;
    });
    }
    else{
      print("Failed to authenticate");
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
    getadata();
    getid();
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedGenres != null) {
        selectedGenres![index] = !selectedGenres![index];
      } // Toggle selection
    });
  }
  Future<void> categorytodb() async {
    print("todb");
    print(id!+"id");
    final response= await http.post(
      Uri.parse("http://"+ip+":8080/finalproject/preftodb.php"),
      body: {
        "id":id.toString(),
        "category":jsonEncode(genretodb)
      }
    );
    print("fromdb");
    if(response.statusCode==200){
      print("Inserted succesfully");
      Navigator.push(context,
        MaterialPageRoute(builder: (context)=> MainPage()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF1F4F8),
        body: !isloading? Center(child: CircularProgressIndicator(),) :Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15,right: 100),
              child: Text(
                "Select the Genre",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
              ),
            ),
            Expanded(
              child: Padding(
                padding:const EdgeInsets.only(top: 20),
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 16),
                    itemCount: genres.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () => toggleSelection(index),
                          child: SizedBox(
                            width: 150,
                              height:100,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                
                                decoration: BoxDecoration(
                                  color: selectedGenres![index]
                                      ? const Color(0xff2A2E34)
                                      : const Color(0xFFFFFFFF),
                                        
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: selectedGenres![index]
                                        ?const Color(0xff2A2E34)
                                        : Colors.transparent,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  genres[index]["lib_text"],
                                  style: TextStyle(
                                    color: selectedGenres![index]
                                        ? Colors.white
                                        : Colors.black, // Text color
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ));
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10,bottom: 20,left: 200),
              child: Container(
                width: 120,
                height: 50,
                child: TextButton(onPressed: (){
                      for(int i=0;i<genres.length;i++){
                        if(selectedGenres![i]==true){
                          genretodb.add(genres[i]["authorized_value"]);
                        }
                      }
                      print(genretodb);
                      if(genretodb.length!=0){
                      categorytodb();
                      }
                      genretodb=[];
                },
                style: TextButton.styleFrom(
                            foregroundColor:const Color(0xFF14181B),
                            backgroundColor:const Color(0xffC5DEDB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            )
                ),
                child: const Text("Next",
                style: TextStyle(
                  fontSize: 16
                ),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
