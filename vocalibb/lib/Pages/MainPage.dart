import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:vocalibb/Pages/Home.dart';

import 'package:vocalibb/Pages/Search.dart';
import 'package:vocalibb/Pages/Settings.dart';
import 'package:vocalibb/Pages/VoicePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages=[HomePage(),SearchPage(),VoicePage(),SettingPage()];
  int index=0;
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      body: pages[index],
      bottomNavigationBar: Container(
        width: double.infinity,
        child: Padding(
          padding:const EdgeInsets.all(8),
          child:  GNav(
            onTabChange: (val){
              setState(() {
                index=val;
              });
            },
            padding: const EdgeInsets.only(left: 20,right: 20, bottom: 20,top: 20),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            gap: 2,
            tabActiveBorder: Border.all(color: Color(0xff2A2E34)),
            tabBackgroundColor:const Color(0xFFFFFFFF),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',),
              GButton(
                icon: Icons.search,
                text: "Search",),
              GButton(
                icon: Icons.voice_chat,
                text: "Voice",),
              GButton(
                icon: Icons.settings,
                text: "Settings", )
            ]),
        ),
      ),
    );
  }
}