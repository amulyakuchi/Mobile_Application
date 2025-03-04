import 'package:flutter_test/flutter_test.dart';
import 'package:nomnom/services/spoonacular_api_service.dart';

void main() {
  group('Ingredient Validation Tests', () {
    late SpoonacularApiService apiService;

    setUp(() {
      apiService = SpoonacularApiService();
    });

    test('Valid ingredient should be accepted', () async {
      // Replace with actual validation logic for your service
      final validIngredient = 'Chicken';
      final isValid = await apiService.validateIngredient(validIngredient);

      expect(isValid, true, reason: 'Valid ingredient should return true');
    });

    test('Invalid ingredient should be rejected', () async {
      // Replace with actual validation logic for your service
      final invalidIngredient = 'kjbeyfb';
      final isValid = await apiService.validateIngredient(invalidIngredient);

      expect(isValid, false, reason: 'Invalid ingredient should return false');
    });

    test('Empty ingredient should be rejected', () async {
      final emptyIngredient = '';
      final isValid = await apiService.validateIngredient(emptyIngredient);

      expect(isValid, false, reason: 'Empty ingredient should return false');
    });
  });
}
