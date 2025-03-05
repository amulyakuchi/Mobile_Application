class Recipe {
  final int id;
  final String title;
  final String imageUrl;
  final int readyInMinutes;
  final List<String> ingredients;
  final List<String> instructions;
  final bool isVegan;
  final bool isGlutenFree;
  final List<String> dietaryPreferences;
  final String summary;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.readyInMinutes,
    required this.ingredients,
    required this.instructions,
    required this.isVegan,
    required this.isGlutenFree,
    required this.dietaryPreferences,
    required this.summary,
  });
  static String _removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final rawSummary = json['summary'] ?? '';
    final cleanedSummary = _removeHtmlTags(rawSummary);

    return Recipe(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['image'] ?? '',
      readyInMinutes: json['readyInMinutes'] ?? 0,
      ingredients: (json['extendedIngredients'] as List<dynamic>?)
          ?.map((e) => e['original'] as String? ?? 'Unknown Ingredient')
          .toList() ??
          [],
      instructions: (json['analyzedInstructions'] as List<dynamic>?)
          ?.expand((instruction) => instruction['steps'] as List<dynamic>? ?? [])
          .map((step) => step['step'] as String? ?? 'No step available')
          .toList() ??
          [],
      isVegan: json['vegan'] ?? false,
      isGlutenFree: json['glutenFree'] ?? false,
      dietaryPreferences: (json['diets'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      summary: cleanedSummary,
    );
  }
}