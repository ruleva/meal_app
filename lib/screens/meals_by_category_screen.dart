import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String categoryName;

  const MealsByCategoryScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  late Future<List<Meal>> _futureMeals;
  List<Meal> _allMeals = [];
  String _search = '';

  @override
  void initState() {
    super.initState();
    _futureMeals = MealApiService.getMealsByCategory(widget.categoryName);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _search = value.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Пребарај јадење...',
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: _futureMeals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Грешка: ${snapshot.error}'),
                  );
                }

                if (_allMeals.isEmpty) {
                  _allMeals = snapshot.data ?? [];
                }

                
                final filtered = _allMeals.where((m) {
                  return m.name.toLowerCase().contains(_search);
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final meal = filtered[index];
                    return MealCard(
                      meal: meal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MealDetailScreen(mealId: meal.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
