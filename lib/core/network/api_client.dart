import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:smart_hair_care/core/network/api_constants.dart';
import 'package:smart_hair_care/core/network/models/models.dart';

part 'api_client.g.dart';

/// Provider for [ApiClient] Retrofit service.
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = _createDio(ApiConstants.openBeautyFactsBaseUrl);
  ref.onDispose(dio.close);
  return ApiClient(dio);
});

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // ==================== Open Beauty Facts ====================

  /// Search for beauty products by category, brand, or other criteria.
  ///
  /// [categoriesTags] - Filter by category (e.g., "shampoo", "conditioner")
  /// [brandsTags] - Filter by brand
  /// [searchTerms] - Free text search
  /// [pageSize] - Number of results per page (default: 20)
  /// [page] - Page number (default: 1)
  @GET('/search')
  Future<ProductSearchResponse> searchBeautyProducts({
    @Query('categories_tags') String? categoriesTags,
    @Query('brands_tags') String? brandsTags,
    @Query('search_terms') String? searchTerms,
    @Query('page_size') int? pageSize,
    @Query('page') int? page,
  });

  // ==================== Open Food Facts ====================

  /// Search for food products (for ingredient analysis).
  ///
  /// Uses Open Food Facts API base URL.
  @GET('${ApiConstants.openFoodFactsBaseUrl}/search')
  Future<ProductSearchResponse> searchFoodProducts({
    @Query('categories_tags') String? categoriesTags,
    @Query('brands_tags') String? brandsTags,
    @Query('search_terms') String? searchTerms,
    @Query('page_size') int? pageSize,
    @Query('page') int? page,
  });
}

Dio _createDio(String baseUrl) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(
        milliseconds: ApiConstants.connectTimeout,
      ),
      receiveTimeout: const Duration(
        milliseconds: ApiConstants.receiveTimeout,
      ),
      sendTimeout: const Duration(
        milliseconds: ApiConstants.sendTimeout,
      ),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    );
  }

  return dio;
}
