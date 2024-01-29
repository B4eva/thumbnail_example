import 'dart:typed_data';

import 'package:flutter/material.dart';

class VideoDetailsPage extends StatefulWidget {
  final ImageProvider<Object> videoPath;
  final Uint8List? videopath2;
  final String fileName;
  const VideoDetailsPage(
      {super.key,
      required this.videoPath,
      required this.fileName,
      this.videopath2});

  @override
  State<VideoDetailsPage> createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 30, 169),
        centerTitle: true,
        title: Text(
          widget.fileName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          widget.videopath2 != null
              ? Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                    // border: Border.all(color: Colors.pink, width: 1.5),
                    image: DecorationImage(
                        image: MemoryImage(widget.videopath2!),
                        fit: BoxFit.cover),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: widget.videoPath, fit: BoxFit.cover),
                  ),
                )
        ],
      ),
    );
  }
}
