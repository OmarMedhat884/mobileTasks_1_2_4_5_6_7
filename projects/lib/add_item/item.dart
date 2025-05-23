import 'dart:io';
class Item {
  List<File> images;
  String title;
  String body;
  bool favorite;

  Item({
    required this.images,
    required this.title,
    required this.body,
    required this.favorite,
  });

  Map<String, dynamic> toJson() {
    return {
      'images': images.map((file) => file.path).toList(),
      'title': title,
      'body': body,
      'favorite': favorite,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      images: (json['images'] as List<dynamic>).map((path) => File(path)).toList(),
      title: json['title'],
      body: json['body'],
      favorite: json['favorite'],
    );
  }
}
