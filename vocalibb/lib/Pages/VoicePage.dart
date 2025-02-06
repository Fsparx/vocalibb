import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:vocalibb/Pages/BookResult.dart';
import 'package:http/http.dart' as http;
import 'package:vocalibb/Pages/globals.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({Key? key}) : super(key: key);

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  final SpeechToText speechToText = SpeechToText();
  bool speechenabled = false;
  String wordspoken = "";
  String bookName = "";
  String action = "";
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    initspeech();
  }

  @override
  void dispose() {
    speechToText.stop();
    speechToText.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!speechToText.isAvailable && !speechenabled) {
      initspeech();
    }
  }

  void initspeech() async {
    speechenabled = await speechToText.initialize(onStatus: onSpeechStatus);
    if (mounted) setState(() {});
  }

  void startlistening() async {
    if (!speechenabled) return;
    await speechToText.listen(
      onResult: onspeechresult,
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        cancelOnError: false,
      ),
    );
    if (mounted) setState(() {});
  }

  void stoplistening() async {
    await speechToText.stop();
    if (mounted) setState(() {});
    processText(wordspoken);
  }

  void onSpeechStatus(String status) async {
    if (status == "notListening") {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) stoplistening();
    }
  }

  void onspeechresult(result) {
    if (mounted) {
      setState(() {
        wordspoken = result.recognizedWords;
      });
    }
  }

  Future<void> processText(String text) async {
    try {
      final response = await http.post(
        Uri.parse("http://$ip:5000/process_text"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': text}),
      );

      if (!mounted) return;
      setState(() {
        isProcessing = false;
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          action = data['action_words'].join(', ');
          bookName = data['book_name'] ?? 'No book found';
        });

        if (bookName != "No book found") {
          _showConfirmationDialog(bookName);
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isProcessing = false;
      });
    }
  }

  void _showConfirmationDialog(String bookName) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Book'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text("Is the book called $bookName?")],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                getbookinfo(bookName);
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
  }

  Future<void> getbookinfo(String book) async {
    try {
      final response = await http.post(
        Uri.parse("http://$ip:8080/finalproject/searchforone.php"),
        body: {"search": book},
      );

      if (response.statusCode == 200) {
        final responsedata = json.decode(response.body);
        if (responsedata.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookInfo(book: responsedata[0]),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: "Book not in inventory",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    } catch (e) {
      print("Error fetching book info: $e");
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
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  speechToText.isListening
                      ? "Listening..."
                      : speechenabled
                          ? "Tap the microphone to start listening"
                          : "Speech not available",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  wordspoken,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: speechToText.isListening ? stoplistening : startlistening,
        child: Icon(speechToText.isListening ? Icons.mic : Icons.mic_off),
      ),
    );
  }
}
