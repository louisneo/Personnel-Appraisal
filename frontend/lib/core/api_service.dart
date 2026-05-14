import 'package:dio/dio.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio dio;

  ApiService._internal() {
    const baseUrl = String.fromEnvironment('API_BASE', defaultValue: 'http://127.0.0.1:8000');
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 5000),
    ));
  }
}

class SpecialTasksApi {
  final Dio _dio = ApiService().dio;

  Future<List<dynamic>> listTasks() async {
    final res = await _dio.get('/special-tasks');
    return res.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> evaluateTask(String id, Map<String, dynamic> payload) async {
    final res = await _dio.post('/special-tasks/$id/evaluate', data: payload);
    return res.data as Map<String, dynamic>;
  }
}