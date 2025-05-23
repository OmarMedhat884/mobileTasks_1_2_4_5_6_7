import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item.dart';

class ItemModel extends ChangeNotifier {
  final List<Item> _items = [];
  final ImagePicker imagePicker = ImagePicker();
  List<File> selectedImages = [];

  List<Item> get items => _items;

  ItemModel() {
    _loadItems();
  }

  void addItem({
    required List<File> itemImages,
    required String title,
    required String body,
    required bool favorite,
  }) {
    _items.add(Item(
      images: itemImages,
      title: title,
      body: body,
      favorite: favorite,
    ));
    _saveItems();
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    _saveItems();
    notifyListeners();
  }

  Future<void> imageSelector() async {
    final List<XFile>? images = await imagePicker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      selectedImages.addAll(images.map((image) => File(image.path)));
      notifyListeners();
    }
  }

  void removeImage(File image) {
    selectedImages.remove(image);
    notifyListeners();
  }

  Item? _selectedItem;
  Item? get selectedItem => _selectedItem;

  void selectItem(Item item) {
    _selectedItem = item;
    notifyListeners();
  }



  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> itemJsonList = _items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('dashboard_items', itemJsonList);
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? itemJsonList = prefs.getStringList('dashboard_items');
    if (itemJsonList != null) {
      _items.clear();
      for (String itemJson in itemJsonList) {
        Map<String, dynamic> jsonMap = jsonDecode(itemJson);
        _items.add(Item.fromJson(jsonMap));
      }
      notifyListeners();
    }
  }
}
