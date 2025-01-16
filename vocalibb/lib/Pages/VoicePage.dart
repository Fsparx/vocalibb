//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
//import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  final SpeechToText speechToText=SpeechToText();
  bool speechenabled=false;
  bool isProcessing=false;
  String wordspoken="";
  double confidence=0;
  String action = "";
  String bookName = "";
  //bool isListening = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initspeech();
  }
  void initspeech() async{
    speechenabled=await speechToText.initialize(
     onStatus: onSpeechStatus,
    //onError: onSpeechError,
    );
    setState(() {});
  }
  void startlistening() async{
    await speechToText.listen(
      onResult:onspeechresult,
      //listenFor: Duration(seconds: 60),
      //pauseFor: Duration(seconds: 5),
      
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        cancelOnError: false) );
      
    setState(() {
      confidence=0;
    });
  }
  void stoplistening() async{
    await speechToText.stop();
    
    //processText(wordspoken);
    //wordspoken="";
    // setState(() {
      
    // });
  }
  void onSpeechStatus(String status) {
    print("Speech status: $status");
    if(status=="done"){
      stoplistening();
    }
    
    // Add logic based on status (e.g., "done", "listening", etc.)
  }
  void onSpeechError(SpeechRecognitionError error) {
    stoplistening();
  }
  void onspeechresult(result){
    setState(() {
      wordspoken="${result.recognizedWords}";
      confidence=result.confidence;
    });
     
  }
  

  Future<void> processText(String text) async {
    print("hii");
    setState(() {
      isProcessing=true;
    });
    //sleep(Duration(seconds: 5));
    await Future.delayed(Duration(seconds: 5));
    final response = await http.post(
      Uri.parse('http://192.168.1.5:5000/process_text'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'text': text}),
    );
    setState(() {
      isProcessing=false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        action = data['action_words'].join(', ');
        bookName = data['book_name'] ?? 'No book found';//Change data here for searchingg
      });
      print(action+"\n"+bookName);
    } else {
      print('Failed to process text');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F4F8),
      body: SafeArea(
        child: Column(
          children: [
            
            
            Padding(
              padding: EdgeInsets.only(left: 10,right: 10,top: 20),
              child: Center(
                child: Text(speechToText.isListening? "Listening.....": 
                speechenabled? "Tap the microphone to start listening":
                "Speech not available",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),),
              ),
            ),
            Expanded(child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(wordspoken,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300
              ) ,))
              ),
          

              
            // if(speechToText.isNotListening && confidence>0)
            //   Padding
              
            //   (padding: EdgeInsets.only(bottom: 100),
            //     child: Text("Confidence: ${confidence*100}")
            //   )
            
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: speechToText.isListening?stoplistening:startlistening,
        child: Icon(speechToText.isNotListening?Icons.mic_off:Icons.mic),
        )
        
    );
  }
}