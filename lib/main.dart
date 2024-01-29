import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thumbnail_app/scr/filechecker.dart';
import 'package:thumbnail_app/scr/video_details_page.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ThumbnailPage(),
    );
  }
}

class ThumbnailPage extends StatefulWidget {
  const ThumbnailPage({super.key});

  @override
  State<ThumbnailPage> createState() => _ThumbnailPageState();
}

class _ThumbnailPageState extends State<ThumbnailPage> {
  final TextEditingController _controller = TextEditingController();

  Uint8List? thumbnail;

  // create an picker object for our image or video
  final ImagePicker picker = ImagePicker();

  // a file object which can be null
  File? file;

  // async call to pick a media file

  Future<void> pickMedia() async {
    final mediaFile = await picker.pickMedia();

    if (mediaFile != null) {
      final file = File(mediaFile.path);
      setState(() {
        this.file = file;
        _controller.text = file.path.split('/').last;
      });
    } else {}
  }

  // generate jpeg thumbnail

  Future<Uint8List?> _generateThumbnail(File file) async {
    final thumbnailAsUint8List = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 320,
        quality: 50);

    thumbnail = thumbnailAsUint8List;

    return thumbnailAsUint8List;
  }

// depending on file type show particular image
  Future<ImageProvider<Object>> _imageProvider(File file) async {
    if (file.fileType == FileType.video) {
      final thumbnail = await _generateThumbnail(file);
      return MemoryImage(thumbnail!);
    } else if (file.fileType == FileType.image) {
      return FileImage(file);
    } else {
      throw Exception('Unsupported media format');
    }
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
        title: const Text(
          'Thumbnail Example',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.pink, width: 1.5),
                    ),
                    child: file == null
                        ? Center(
                            child: InkWell(
                                onTap: () {
                                  pickMedia();
                                },
                                child: const Text('Click to select File')),
                          )
                        : FutureBuilder(
                            future: _imageProvider(file!),
                            builder: (context, snapshot) {
                              if (snapshot.data != null &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  width: MediaQuery.of(context).size.height / 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.pink, width: 1.5),
                                    image: DecorationImage(
                                        image: snapshot.data!,
                                        fit: BoxFit.cover),
                                  ),
                                );
                              }
                              return const Center(
                                child: Text('No File attached'),
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8.0),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.height / 1.5,
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Select Any file type',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.attach_file),
                            onPressed: () {
                              pickMedia();
                            },
                          )),
                      controller: _controller,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoDetailsPage(
                              file: file,
                              videopath2: thumbnail,
                              videoPath: FileImage(file!),
                              fileName: file?.path.split('/').last ?? ''),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 208, 144, 166)),
                      width: double.infinity,
                      height: 50,
                      child: const Center(
                          child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w800),
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 70,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
