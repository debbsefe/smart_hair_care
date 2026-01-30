import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_product.freezed.dart';
part 'api_product.g.dart';

/// Represents a beauty/hair care product from Open Beauty Facts API.
@freezed
sealed class ApiProduct with _$ApiProduct {
  const factory ApiProduct({
    /// Product barcode/ID (e.g., "3760346072747")
    @JsonKey(name: '_id') String? id,

    /// Product barcode
    String? code,

    /// Product name
    @JsonKey(name: 'product_name') String? productName,

    /// Brand name
    String? brands,

    /// Product categories
    String? categories,

    /// Raw ingredients text
    @JsonKey(name: 'ingredients_text') String? ingredientsText,

    /// Product image URL
    @JsonKey(name: 'image_url') String? imageUrl,

    /// Small product image URL
    @JsonKey(name: 'image_small_url') String? imageSmallUrl,

    /// Front image URL
    @JsonKey(name: 'image_front_url') String? imageFrontUrl,

    /// Product quantity (e.g., "250ml")
    String? quantity,
  }) = _ApiProduct;

  factory ApiProduct.fromJson(Map<String, dynamic> json) =>
      _$ApiProductFromJson(json);
}
