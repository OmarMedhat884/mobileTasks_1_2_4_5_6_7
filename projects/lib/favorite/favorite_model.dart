import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../add_item/item.dart';

class FavoriteModel extends ChangeNotifier {
  final List<Item> _fav = [];

  List<Item> get fav => _fav;

  FavoriteModel() {
    _loadFavorites();
  }

  void add(Item item) {
    if (!_fav.contains(item)) {
      _fav.add(item);
      _saveFavorites();
    }
    notifyListeners();
  }

  void remove(Item item) {
    if (_fav.contains(item)) {
      _fav.remove(item);
      _saveFavorites();
    }
    notifyListeners();
  }

  void isFavorite(Item item) {
    item.favorite = !item.favorite;
    item.favorite ? add(item) : remove(item);
    notifyListeners();
  }

  // ✅ حفظ المفضلة
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favJsonList = _fav.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('favorite_items', favJsonList);
  }

  // ✅ تحميل المفضلة
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favJsonList = prefs.getStringList('favorite_items');
    if (favJsonList != null) {
      _fav.clear();
      for (String itemJson in favJsonList) {
        Map<String, dynamic> jsonMap = jsonDecode(itemJson);
        _fav.add(Item.fromJson(jsonMap));
      }
      notifyListeners();
    }
  }
}
