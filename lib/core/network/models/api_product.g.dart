// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiProduct _$ApiProductFromJson(Map<String, dynamic> json) => _ApiProduct(
  id: json['_id'] as String?,
  code: json['code'] as String?,
  productName: json['product_name'] as String?,
  brands: json['brands'] as String?,
  categories: json['categories'] as String?,
  ingredientsText: json['ingredients_text'] as String?,
  imageUrl: json['image_url'] as String?,
  imageSmallUrl: json['image_small_url'] as String?,
  imageFrontUrl: json['image_front_url'] as String?,
  quantity: json['quantity'] as String?,
);

Map<String, dynamic> _$ApiProductToJson(_ApiProduct instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'code': instance.code,
      'product_name': instance.productName,
      'brands': instance.brands,
      'categories': instance.categories,
      'ingredients_text': instance.ingredientsText,
      'image_url': instance.imageUrl,
      'image_small_url': instance.imageSmallUrl,
      'image_front_url': instance.imageFrontUrl,
      'quantity': instance.quantity,
    };
