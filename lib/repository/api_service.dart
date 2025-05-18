import 'package:dio/dio.dart';
import 'package:fit_track/model/food_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  final Dio dio = Dio();
  final String baseUrl = dotenv.env['BASE_URL']!;
  final String apiKey = dotenv.env['CALORIE_NINJAS_API_KEY']!;

  Future<List<Food>> searchFood(String query) async {
    try {
      final response = await dio.get(
        '$baseUrl?query=${Uri.encodeQueryComponent(query.trim())}',
        options: Options(
          headers: {'X-Api-Key': apiKey},
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
