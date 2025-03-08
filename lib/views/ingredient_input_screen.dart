import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/search_viewmodel.dart';
import '../services/spoonacular_api_service.dart';


class IngredientInputScreen extends StatefulWidget {
  const IngredientInputScreen({Key? key}) : super(key: key);

  @override
  State<IngredientInputScreen> createState() => _IngredientInputScreenState();
}

class _IngredientInputScreenState extends State<IngredientInputScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final List<String> _ingredients = [];
  final SpoonacularApiService _apiService = SpoonacularApiService();

  
  String selectedDietaryPreference = 'Any';
  String selectedCuisine = 'Any';
  String selectedDishType = 'Any';
  double maxCookingTime = 60;
  int numberOfResults = 10;

  
  final List<String> dietaryOptions = [
    'Any',
    'Vegan',
    'Gluten-Free',
    'Vegetarian',
    'Ketogenic',
    'Paleo',
    'Pescatarian',
  ];

  final List<String> cuisineOptions = [
    'Any',
    'American',
    'Chinese',
    'French',
    'Indian',
    'Italian',
    'Mexican',
  ];

  final List<String> dishTypeOptions = [
    'Any',
    'Main Course',
    'Side Dish',
    'Dessert',
    'Appetizer',
    'Beverage',
    'Snack',
  ];

  
  Future<void> _addIngredient() async {
    final ingredient = _ingredientController.text.trim();
    if (ingredient.isEmpty) return;

    
    final isValid = await _apiService.validateIngredient(ingredient);

    if (isValid) {
      
      if (!_ingredients.contains(ingredient)) {
        setState(() {
          _ingredients.add(ingredient);
          _ingredientController.clear();
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid ingredient. Please enter a valid food item.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() => _ingredients.remove(ingredient));
  }

  Widget _buildIngredientChips() {
    if (_ingredients.isEmpty) {
      return const Text(
        'No ingredients added yet.',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: _ingredients.map((ingredient) {
        return Chip(
          label: Text(ingredient),
          deleteIcon: const Icon(Icons.close),
          onDeleted: () => _removeIngredient(ingredient),
        );
      }).toList(),
    );
  }

  Widget _buildDropdownFilter({
    required String label,
    required List<String> options,
    required String selectedValue,
    required void Function(String?) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        DropdownButton<String>(
          value: selectedValue,
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchVM = Provider.of<SearchViewModel>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Ingredients'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ingredientController,
              decoration: InputDecoration(
                labelText: 'Type an ingredient',
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: isDarkMode ? Colors.teal : Colors.green,
                  ),
                  onPressed: _addIngredient,
                ),
              ),
              onSubmitted: (_) => _addIngredient(),
            ),
            const SizedBox(height: 16),
            _buildIngredientChips(),
            const SizedBox(height: 16),

            
            _buildDropdownFilter(
              label: 'Dietary Preference',
              options: dietaryOptions,
              selectedValue: selectedDietaryPreference,
              onChanged: (value) => setState(() {
                selectedDietaryPreference = value!;
              }),
            ),
            const SizedBox(height: 12),
            _buildDropdownFilter(
              label: 'Cuisine',
              options: cuisineOptions,
              selectedValue: selectedCuisine,
              onChanged: (value) => setState(() {
                selectedCuisine = value!;
              }),
            ),
            const SizedBox(height: 12),
            _buildDropdownFilter(
              label: 'Dish Type',
              options: dishTypeOptions,
              selectedValue: selectedDishType,
              onChanged: (value) => setState(() {
                selectedDishType = value!;
              }),
            ),
            const SizedBox(height: 12),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Max Cooking Time (minutes)'),
                Text('${maxCookingTime.round()}'),
              ],
            ),
            Slider(
              min: 0,
              max: 120,
              divisions: 12,
              label: '${maxCookingTime.round()}',
              value: maxCookingTime,
              onChanged: (val) {
                setState(() => maxCookingTime = val);
              },
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Number of Results'),
                Text('$numberOfResults'),
              ],
            ),
            Slider(
              min: 1,
              max: 20,
              divisions: 19,
              label: '$numberOfResults',
              value: numberOfResults.toDouble(),
              onChanged: (val) {
                setState(() => numberOfResults = val.toInt());
              },
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.teal.shade800 : Colors.green.shade700,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _ingredients.isEmpty
                  ? null
                  : () async {
                await searchVM.searchRecipes(
                  ingredients: _ingredients.join(','),
                  dietaryPreference: selectedDietaryPreference,
                  numberOfResults: numberOfResults,
                  cuisine: selectedCuisine,
                  dishType: selectedDishType,
                );
                Navigator.pushNamed(context, '/recipe_list');
              },
              child: const Text('Search Recipes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
