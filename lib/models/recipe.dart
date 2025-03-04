/// The Recipe class represents a recipe with its details.
class Recipe {
  final int id; // Unique identifier for the recipe
  final String title; // Title of the recipe
  final String imageUrl; // URL of the recipe image
  final int readyInMinutes; // Estimated time to prepare the recipe (in minutes)
  final List<String> ingredients; // Ingredients required for the recipe
  final List<String> instructions; // Step-by-step instructions for the recipe
  final bool isVegan; // Indicates if the recipe is vegan
  final bool isGlutenFree; // Indicates if the recipe is gluten-free
  final List<String> dietaryPreferences; // List of dietary preferences for the recipe

  /// Constructor for creating a Recipe object.
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
  });

  /// Factory method to create a Recipe object from a JSON response.
  ///
  /// This method is used to parse data from Spoonacular API responses.
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['image'] ?? '',
      readyInMinutes: json['readyInMinutes'] ?? 0,
      ingredients: (json['extendedIngredients'] as List<dynamic>?)
          ?.map((e) => e['original'] as String)
          .toList() ??
          [],
      instructions: (json['analyzedInstructions'] as List<dynamic>?)
          ?.expand((instruction) => instruction['steps'] as List<dynamic>)
          .map((step) => step['step'] as String)
          .toList() ??
          [],
      isVegan: json['vegan'] ?? false,
      isGlutenFree: json['glutenFree'] ?? false,
      dietaryPreferences: (json['diets'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}