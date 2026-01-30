import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hair_care/core/network/models/api_product.dart';

part 'product_search_response.freezed.dart';
part 'product_search_response.g.dart';

/// Converts a value that may be int or String to int.
class CustomIntConverter implements JsonConverter<int?, dynamic> {
  const CustomIntConverter();

  @override
  int? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is int) return json;
    if (json is String) return int.tryParse(json);
    return null;
  }

  @override
  dynamic toJson(int? object) => object;
}

/// Response from the Open Beauty Facts product search API.
@freezed
sealed class ProductSearchResponse with _$ProductSearchResponse {
  const factory ProductSearchResponse({
    /// Total count of products matching the search
    @CustomIntConverter() @Default(0) int? count,

    /// Current page number (API returns string or int)
    @CustomIntConverter() @Default(1) int? page,

    /// Number of products in the current page
    @JsonKey(name: 'page_count')
    @CustomIntConverter()
    @Default(0)
    int? pageCount,

    /// Page size
    @JsonKey(name: 'page_size')
    @CustomIntConverter()
    @Default(20)
    int? pageSize,

    /// List of products
    @Default([]) List<ApiProduct> products,
  }) = _ProductSearchResponse;

  factory ProductSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductSearchResponseFromJson(json);
}
