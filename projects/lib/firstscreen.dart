import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home/home_screen/home_page.dart';

class Firstscreen extends StatefulWidget {
  const Firstscreen({super.key});

  @override
  State<Firstscreen> createState() => _FirstscreenState();
}

class _FirstscreenState extends State<Firstscreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<File> selectedImage = [];

  Future<void> imageSelector() async {
    List<XFile>? images = await imagePicker.pickMultiImage();
    if (mounted) {
      setState(() {
        selectedImage.addAll(images.map((xfile) => File(xfile.path)).toList());
      });
    }
  }

  final TextEditingController title = TextEditingController();
  final TextEditingController body = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/background.jpg"),
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 30),
            selectedImage.isEmpty
                ? Container(
              color: Colors.white38,
              height: 150,
              width: screenWidth - 20,
              child: IconButton(
                onPressed: imageSelector,
                icon: const Icon(Icons.camera_alt),
              ),
            )
                : Row(
              children: [
                Container(
                  color: Colors.white38,
                  height: 100,
                  width: 100,
                  child: IconButton(
                    onPressed: imageSelector,
                    icon: const Icon(Icons.camera_alt),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: screenWidth - 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: selectedImage.map((file) {
                      return Stack(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                            child: Image.file(
                              file,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  selectedImage.remove(file);
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: title,
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: body,
                minLines: 3,
                maxLines: 7,
                decoration: const InputDecoration(
                  hintText: "Body",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                title: title.text,
                body: body.text,
                image: selectedImage,
              ),
            ),
          );
        },
      ),
    );
  }
}
