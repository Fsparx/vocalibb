import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vocalibb/Pages/BookResult.dart';
import 'package:vocalibb/Pages/globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = "";
  Map<String, dynamic>? body;
 
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
    setbooks(id);
    getToken(id);
  }

  Future<void> setbooks(String id) async {
    print("hiii");
    final response = await http.post(
        Uri.parse("http://" + ip + ":8080/finalproject/getbookinfo.php"),
        body: {
          "id": id,
        });
    if (response.statusCode == 200) {
      body = json.decode(response.body);
      print(body);
      //print(body!["ECONOMICS"][0]["bid"]);
      setState(() {
        body;
      });
    }
  }

void getToken(String id) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // Get the FCM token
    String? token = await messaging.getToken();
    print("FCM Token: $token");

    // Save token to MySQL via API
    saveTokenToDatabase(token,id);
  } else {
    print("Notification permission denied");
  }
}


void saveTokenToDatabase(String? token,String id) async {
  if (token == null) return;

  final response = await http.post(
    Uri.parse("http://" + ip + ":8080/finalproject/storefcm.php"),
    body: {
      "uid": id, // Example User ID
      "fcm_token": token,
    },
  );

  print(response.body);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F4F8),
      body: SafeArea(
          child: Expanded(
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text("Welcome $_name",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: body==null ?[]: body?.entries.map((entry) {
                    final departmentName = entry.key;
                    final books =
                        (entry.value as List).cast<Map<String, dynamic>>();
                    print(books);
                    print("inside entry");
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            departmentName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: books.map((book) {
                                String isbn = book["isbn"];
                                String link="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png";
                                if(isbn!=""){
                                  link="https://covers.openlibrary.org/b/isbn/$isbn-M.jpg";
                                }
                                return Padding(
                                  padding: EdgeInsets.all(8),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                          MaterialPageRoute(
                                            builder: (context) => BookInfo(book: book,),
                                        ),
                                        );
                                    },
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            link,
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            book['title'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ))
                      ],
                    );
                  }).toList() ??
                  [],
            ),
            
            // const Padding(
            //   padding: EdgeInsets.only(left: 10, top: 10),
            //   child: Text("Genres",
            //   style: TextStyle(
            //     fontWeight:FontWeight.w600,
            //     fontSize: 18,
            //   ),),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8),
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       children: items.map((item) {
            //         return Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //           child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               ClipRRect(
            //                 borderRadius: BorderRadius.circular(
            //                     8.0),
            //                 child: Image.network(
            //                   item['url']!,
            //                   width: 90,
            //                   height: 90,
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //               SizedBox(height: 4),
            //               Text(
            //                 item['title']!,
            //                 style: TextStyle(
            //                     fontSize: 14, fontWeight: FontWeight.w500),
            //                 textAlign: TextAlign.center,
            //               ),
            //             ],
            //           ),
            //         );
            //       }).toList(),
            //     ),
            //   ),
            // ),
                    ],
                  ),
          )),
    );
  }
}
