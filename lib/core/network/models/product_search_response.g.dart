// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductSearchResponse _$ProductSearchResponseFromJson(
  Map<String, dynamic> json,
) => _ProductSearchResponse(
  count: json['count'] == null
      ? 0
      : const CustomIntConverter().fromJson(json['count']),
  page: json['page'] == null
      ? 1
      : const CustomIntConverter().fromJson(json['page']),
  pageCount: json['page_count'] == null
      ? 0
      : const CustomIntConverter().fromJson(json['page_count']),
  pageSize: json['page_size'] == null
      ? 20
      : const CustomIntConverter().fromJson(json['page_size']),
  products:
      (json['products'] as List<dynamic>?)
          ?.map((e) => ApiProduct.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProductSearchResponseToJson(
  _ProductSearchResponse instance,
) => <String, dynamic>{
  'count': const CustomIntConverter().toJson(instance.count),
  'page': const CustomIntConverter().toJson(instance.page),
  'page_count': const CustomIntConverter().toJson(instance.pageCount),
  'page_size': const CustomIntConverter().toJson(instance.pageSize),
  'products': instance.products,
};
