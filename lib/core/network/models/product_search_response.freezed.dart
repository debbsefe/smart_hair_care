// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_search_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductSearchResponse {

/// Total count of products matching the search
@CustomIntConverter() int get count;/// Current page number (API returns string or int)
@CustomIntConverter() int get page;/// Number of products in the current page
@JsonKey(name: 'page_count')@CustomIntConverter() int get pageCount;/// Page size
@JsonKey(name: 'page_size')@CustomIntConverter() int get pageSize;/// List of products
 List<ApiProduct> get products;
/// Create a copy of ProductSearchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSearchResponseCopyWith<ProductSearchResponse> get copyWith => _$ProductSearchResponseCopyWithImpl<ProductSearchResponse>(this as ProductSearchResponse, _$identity);

  /// Serializes this ProductSearchResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSearchResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&const DeepCollectionEquality().equals(other.products, products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,page,pageCount,pageSize,const DeepCollectionEquality().hash(products));

@override
String toString() {
  return 'ProductSearchResponse(count: $count, page: $page, pageCount: $pageCount, pageSize: $pageSize, products: $products)';
}


}

/// @nodoc
abstract mixin class $ProductSearchResponseCopyWith<$Res>  {
  factory $ProductSearchResponseCopyWith(ProductSearchResponse value, $Res Function(ProductSearchResponse) _then) = _$ProductSearchResponseCopyWithImpl;
@useResult
$Res call({
@CustomIntConverter() int count,@CustomIntConverter() int page,@JsonKey(name: 'page_count')@CustomIntConverter() int pageCount,@JsonKey(name: 'page_size')@CustomIntConverter() int pageSize, List<ApiProduct> products
});




}
/// @nodoc
class _$ProductSearchResponseCopyWithImpl<$Res>
    implements $ProductSearchResponseCopyWith<$Res> {
  _$ProductSearchResponseCopyWithImpl(this._self, this._then);

  final ProductSearchResponse _self;
  final $Res Function(ProductSearchResponse) _then;

/// Create a copy of ProductSearchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? page = null,Object? pageCount = null,Object? pageSize = null,Object? products = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ApiProduct>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSearchResponse].
extension ProductSearchResponsePatterns on ProductSearchResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSearchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSearchResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSearchResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProductSearchResponse():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSearchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSearchResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@CustomIntConverter()  int count, @CustomIntConverter()  int page, @JsonKey(name: 'page_count')@CustomIntConverter()  int pageCount, @JsonKey(name: 'page_size')@CustomIntConverter()  int pageSize,  List<ApiProduct> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSearchResponse() when $default != null:
return $default(_that.count,_that.page,_that.pageCount,_that.pageSize,_that.products);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@CustomIntConverter()  int count, @CustomIntConverter()  int page, @JsonKey(name: 'page_count')@CustomIntConverter()  int pageCount, @JsonKey(name: 'page_size')@CustomIntConverter()  int pageSize,  List<ApiProduct> products)  $default,) {final _that = this;
switch (_that) {
case _ProductSearchResponse():
return $default(_that.count,_that.page,_that.pageCount,_that.pageSize,_that.products);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@CustomIntConverter()  int count, @CustomIntConverter()  int page, @JsonKey(name: 'page_count')@CustomIntConverter()  int pageCount, @JsonKey(name: 'page_size')@CustomIntConverter()  int pageSize,  List<ApiProduct> products)?  $default,) {final _that = this;
switch (_that) {
case _ProductSearchResponse() when $default != null:
return $default(_that.count,_that.page,_that.pageCount,_that.pageSize,_that.products);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductSearchResponse implements ProductSearchResponse {
  const _ProductSearchResponse({@CustomIntConverter() this.count = 0, @CustomIntConverter() this.page = 1, @JsonKey(name: 'page_count')@CustomIntConverter() this.pageCount = 0, @JsonKey(name: 'page_size')@CustomIntConverter() this.pageSize = 20, final  List<ApiProduct> products = const []}): _products = products;
  factory _ProductSearchResponse.fromJson(Map<String, dynamic> json) => _$ProductSearchResponseFromJson(json);

/// Total count of products matching the search
@override@JsonKey()@CustomIntConverter() final  int count;
/// Current page number (API returns string or int)
@override@JsonKey()@CustomIntConverter() final  int page;
/// Number of products in the current page
@override@JsonKey(name: 'page_count')@CustomIntConverter() final  int pageCount;
/// Page size
@override@JsonKey(name: 'page_size')@CustomIntConverter() final  int pageSize;
/// List of products
 final  List<ApiProduct> _products;
/// List of products
@override@JsonKey() List<ApiProduct> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of ProductSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSearchResponseCopyWith<_ProductSearchResponse> get copyWith => __$ProductSearchResponseCopyWithImpl<_ProductSearchResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductSearchResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSearchResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&const DeepCollectionEquality().equals(other._products, _products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,page,pageCount,pageSize,const DeepCollectionEquality().hash(_products));

@override
String toString() {
  return 'ProductSearchResponse(count: $count, page: $page, pageCount: $pageCount, pageSize: $pageSize, products: $products)';
}


}

/// @nodoc
abstract mixin class _$ProductSearchResponseCopyWith<$Res> implements $ProductSearchResponseCopyWith<$Res> {
  factory _$ProductSearchResponseCopyWith(_ProductSearchResponse value, $Res Function(_ProductSearchResponse) _then) = __$ProductSearchResponseCopyWithImpl;
@override @useResult
$Res call({
@CustomIntConverter() int count,@CustomIntConverter() int page,@JsonKey(name: 'page_count')@CustomIntConverter() int pageCount,@JsonKey(name: 'page_size')@CustomIntConverter() int pageSize, List<ApiProduct> products
});




}
/// @nodoc
class __$ProductSearchResponseCopyWithImpl<$Res>
    implements _$ProductSearchResponseCopyWith<$Res> {
  __$ProductSearchResponseCopyWithImpl(this._self, this._then);

  final _ProductSearchResponse _self;
  final $Res Function(_ProductSearchResponse) _then;

/// Create a copy of ProductSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? page = null,Object? pageCount = null,Object? pageSize = null,Object? products = null,}) {
  return _then(_ProductSearchResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ApiProduct>,
  ));
}


}

// dart format on
