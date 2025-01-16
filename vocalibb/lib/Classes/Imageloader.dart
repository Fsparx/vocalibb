import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetworkImageWithTimeout extends StatelessWidget {
  final String imageUrl;
  final String fallbackImageUrl;
  final Duration timeoutDuration;

  const NetworkImageWithTimeout({
    Key? key,
    required this.imageUrl,
    required this.fallbackImageUrl,
    this.timeoutDuration = const Duration(seconds: 5),
  }) : super(key: key);

  Future<bool> _checkImage(String url) async {
    try {
      final response = await NetworkAssetBundle(Uri.parse(url)).load(url).timeout(timeoutDuration);
      return response.lengthInBytes > 0;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the image is loading
          return Container(
            width: 90,
            height: 90,
            color: Colors.grey.shade300,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
          // Image loaded successfully
          return Image.network(
            imageUrl,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          );
        } else {
          // Fallback to default image
          return Image.network(
            fallbackImageUrl,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          );
        }
      },
    );
  }
}
