import 'package:dio/dio.dart';
import 'dio_client.dart';

class NetworkExecutor {
  final DioClient _dioClient;

  NetworkExecutor(this._dioClient);

  Future<Response> executePost({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dioClient.instance.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection Timeout";
      case DioExceptionType.badResponse:
        return error.response?.data['message'] ?? "Server Error";
      default:
        return "Something went wrong";
    }
  }
}