import 'package:dio/dio.dart';
import 'package:fit_track/model/food_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://api.calorieninjas.com/v1/nutrition';
  static const String _apiKey = 'JtNxkJ1JDdonSNvO9iqGJw==Psuzv4GDqHWUt02M';

  Future<List<Food>> searchFood(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl?query=${Uri.encodeQueryComponent(query.trim())}',
        options: Options(
          headers: {'X-Api-Key': _apiKey},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid API key. Please verify your CalorieNinjas API key.');
      }

      if (response.data == null || response.data['items'] == null) {
        throw Exception('Invalid response format from API.');
      }

      final items = response.data['items'] as List<dynamic>;
      return items.map((item) => Food.fromJson(item)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Invalid API key. Please verify your CalorieNinjas API key.');
      }
      throw Exception('Failed to fetch food data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch food data: $e');
    }
  }
}
