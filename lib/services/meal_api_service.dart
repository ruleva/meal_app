import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class MealApiService {
  static const String _baseUrl = 'www.themealdb.com';

  static Future<List<Category>> getCategories() async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/categories.php');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['categories'];
      return list.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Не успеа categories request');
    }
  }

  static Future<List<Meal>> getMealsByCategory(String category) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/json/v1/1/filter.php',
      {'c': category},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['meals'] ?? [];
      return list.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Не успеа meals by category');
    }
  }

  static Future<List<Meal>> searchMeals(String query) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/json/v1/1/search.php',
      {'s': query},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List? list = data['meals'];
      if (list == null) return [];
      return list.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Не успеа search meals');
    }
  }

  static Future<MealDetail> getMealDetail(String id) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/json/v1/1/lookup.php',
      {'i': id},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['meals'];
      return MealDetail.fromJson(list[0]);
    } else {
      throw Exception('Не успеа meal detail');
    }
  }

  static Future<MealDetail> getRandomMeal() async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/random.php');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['meals'];
      return MealDetail.fromJson(list[0]);
    } else {
      throw Exception('Не успеа random meal');
    }
  }
}
