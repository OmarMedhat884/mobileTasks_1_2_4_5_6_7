import 'package:flutter/material.dart';

class PageScreen extends StatelessWidget {
  const PageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "We're built for software teams",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "عمر مدحت محمد 20230469240",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "حسن فتحي علي 20230537034",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "كريم كمال حسن 20230469244",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "يوسف صلاح محمد 20230469266",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "سيف الدين وائل إبراهيم 20230469228",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            const Text(
              "Below are different versions of the tree images",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: const [
                  ImageWithLabel(
                    imagePath: "assets/Tree.jpg",
                    label: "Original Tree",
                  ),
                  ImageWithLabel(
                    imagePath: "assets/Tree_new.jpg",
                    label: "New Tree",
                  ),
                  ImageWithLabel(
                    imagePath: "assets/Tree_old.jpg",
                    label: "Old Tree",
                  ),
                  ImageWithLabel(
                    imagePath: "assets/Tree.jpg",
                    label: "Original Tree",
                  ),
                  ImageWithLabel(
                    imagePath: "assets/Tree_new.jpg",
                    label: "New Tree",
                  ),
                  ImageWithLabel(
                    imagePath: "assets/Tree_old.jpg",
                    label: "Old Tree",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageWithLabel extends StatelessWidget {
  final String imagePath;
  final String label;

  const ImageWithLabel({
    super.key,
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
