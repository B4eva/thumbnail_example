import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetailsPage extends StatefulWidget {
  final ImageProvider<Object> videoPath;
  final Uint8List? videopath2;
  final String fileName;
  final File? file;
  const VideoDetailsPage(
      {super.key,
      required this.videoPath,
      required this.fileName,
      this.videopath2,
      this.file});

  @override
  State<VideoDetailsPage> createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.file(widget.file!);

    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

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
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(_controller),
                )

              // Container(
              //     height: MediaQuery.of(context).size.height / 2,
              //     width: MediaQuery.of(context).size.height,
              //     decoration: BoxDecoration(
              //       // borderRadius: BorderRadius.circular(20),
              //       // border: Border.all(color: Colors.pink, width: 1.5),
              //       image: DecorationImage(
              //           image: MemoryImage(widget.videopath2!),
              //           fit: BoxFit.cover),
              //     ),
              //   )
              : Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: widget.videoPath, fit: BoxFit.cover),
                  ),
                ),
        ],
      ),
      floatingActionButton: widget.videopath2 != null
          ? FloatingActionButton(
              onPressed: () {
                // Wrap the play or pause in a call to `setState`. This ensures the
                // correct icon is shown.
                setState(() {
                  // If the video is playing, pause it.
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    // If the video is paused, play it.
                    _controller.play();
                  }
                });
              },
              // Display the correct icon depending on the state of the player.
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : const SizedBox(),
    );
  }
}
