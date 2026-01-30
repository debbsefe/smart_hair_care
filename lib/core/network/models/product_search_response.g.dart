// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductSearchResponse _$ProductSearchResponseFromJson(
  Map<String, dynamic> json,
) => _ProductSearchResponse(
  count: (json['count'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 1,
  pageCount: (json['page_count'] as num?)?.toInt() ?? 0,
  pageSize: (json['page_size'] as num?)?.toInt() ?? 20,
  products:
      (json['products'] as List<dynamic>?)
          ?.map((e) => ApiProduct.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProductSearchResponseToJson(
  _ProductSearchResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'page': instance.page,
  'page_count': instance.pageCount,
  'page_size': instance.pageSize,
  'products': instance.products,
};
