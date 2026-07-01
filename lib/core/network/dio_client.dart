// import 'package:dio/dio.dart';
// import 'package:neuronest/core/utils/pref_helpers.dart';

// class DioClient {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: 'http://austimaiapp.runasp.net/api',
//       // headers: {'Content-Type': 'application/json'},
//       connectTimeout: const Duration(seconds: 30),
//       sendTimeout: const Duration(minutes: 2),
//       receiveTimeout: const Duration(minutes: 2),
//     ),
//   );

//   DioClient() {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           final token = await PrefHelper.getToken();
//           if (token != null && token.isNotEmpty) {
//             options.headers['Authorization'] = 'Bearer $token';
//           }
//           return handler.next(options);
//         },
//       ),
//     );
//   }

//   Dio get dio => _dio;
// }

import 'package:dio/dio.dart';
import 'package:neuronest/core/routes/nav_key.dart';
import 'package:neuronest/core/utils/pref_helpers.dart';

class DioClient {
  // We need to change this to HTTPS once the backend is Changed to HTTPS
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://austimaiapp.runasp.net/api',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(
        minutes: 3,
      ),
      receiveTimeout: const Duration(minutes: 3),
    ),
  );

  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // PrefHelper now securely fetches the token via FlutterSecureStorage
          final token = await PrefHelper.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log or modify successful responses here if needed
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          // Handle 401 Unauthorized globally (Token Expired)
          if (e.response?.statusCode == 401) {
            // Clear the invalid token securely
            await PrefHelper.clearToken();

            NavKey.navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }

          return handler.next(e);
        },
      ),
    );

    // Optional: Add a logger interceptor for local debugging
    // This helps you see exactly what the API is doing without cluttering UI code
    _dio.interceptors.add(
      LogInterceptor(
        requestBody:
            false, // Set to true if you need to debug payloads (turn off for prod)
        responseBody: false,
        error: true,
      ),
    );
  }

  Dio get dio => _dio;
}
