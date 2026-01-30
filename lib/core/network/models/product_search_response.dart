import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hair_care/core/network/models/api_product.dart';

part 'product_search_response.freezed.dart';
part 'product_search_response.g.dart';

/// Response from the Open Beauty Facts product search API.
@freezed
sealed class ProductSearchResponse with _$ProductSearchResponse {
  const factory ProductSearchResponse({
    /// Total count of products matching the search
    @Default(0) int count,

    /// Current page number
    @Default(1) int page,

    /// Number of products in the current page
    @JsonKey(name: 'page_count') @Default(0) int pageCount,

    /// Page size
    @JsonKey(name: 'page_size') @Default(20) int pageSize,

    /// List of products
    @Default([]) List<ApiProduct> products,
  }) = _ProductSearchResponse;

  factory ProductSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductSearchResponseFromJson(json);
}
