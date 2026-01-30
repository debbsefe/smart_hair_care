// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiProduct {

/// Product barcode/ID (e.g., "3760346072747")
@JsonKey(name: '_id') String? get id;/// Product barcode
 String? get code;/// Product name
@JsonKey(name: 'product_name') String? get productName;/// Brand name
 String? get brands;/// Product categories
 String? get categories;/// Raw ingredients text
@JsonKey(name: 'ingredients_text') String? get ingredientsText;/// Product image URL
@JsonKey(name: 'image_url') String? get imageUrl;/// Small product image URL
@JsonKey(name: 'image_small_url') String? get imageSmallUrl;/// Front image URL
@JsonKey(name: 'image_front_url') String? get imageFrontUrl;/// Product quantity (e.g., "250ml")
 String? get quantity;
/// Create a copy of ApiProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiProductCopyWith<ApiProduct> get copyWith => _$ApiProductCopyWithImpl<ApiProduct>(this as ApiProduct, _$identity);

  /// Serializes this ApiProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.brands, brands) || other.brands == brands)&&(identical(other.categories, categories) || other.categories == categories)&&(identical(other.ingredientsText, ingredientsText) || other.ingredientsText == ingredientsText)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageSmallUrl, imageSmallUrl) || other.imageSmallUrl == imageSmallUrl)&&(identical(other.imageFrontUrl, imageFrontUrl) || other.imageFrontUrl == imageFrontUrl)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,productName,brands,categories,ingredientsText,imageUrl,imageSmallUrl,imageFrontUrl,quantity);

@override
String toString() {
  return 'ApiProduct(id: $id, code: $code, productName: $productName, brands: $brands, categories: $categories, ingredientsText: $ingredientsText, imageUrl: $imageUrl, imageSmallUrl: $imageSmallUrl, imageFrontUrl: $imageFrontUrl, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $ApiProductCopyWith<$Res>  {
  factory $ApiProductCopyWith(ApiProduct value, $Res Function(ApiProduct) _then) = _$ApiProductCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String? id, String? code,@JsonKey(name: 'product_name') String? productName, String? brands, String? categories,@JsonKey(name: 'ingredients_text') String? ingredientsText,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'image_small_url') String? imageSmallUrl,@JsonKey(name: 'image_front_url') String? imageFrontUrl, String? quantity
});




}
/// @nodoc
class _$ApiProductCopyWithImpl<$Res>
    implements $ApiProductCopyWith<$Res> {
  _$ApiProductCopyWithImpl(this._self, this._then);

  final ApiProduct _self;
  final $Res Function(ApiProduct) _then;

/// Create a copy of ApiProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? code = freezed,Object? productName = freezed,Object? brands = freezed,Object? categories = freezed,Object? ingredientsText = freezed,Object? imageUrl = freezed,Object? imageSmallUrl = freezed,Object? imageFrontUrl = freezed,Object? quantity = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,brands: freezed == brands ? _self.brands : brands // ignore: cast_nullable_to_non_nullable
as String?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as String?,ingredientsText: freezed == ingredientsText ? _self.ingredientsText : ingredientsText // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageSmallUrl: freezed == imageSmallUrl ? _self.imageSmallUrl : imageSmallUrl // ignore: cast_nullable_to_non_nullable
as String?,imageFrontUrl: freezed == imageFrontUrl ? _self.imageFrontUrl : imageFrontUrl // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiProduct].
extension ApiProductPatterns on ApiProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiProduct value)  $default,){
final _that = this;
switch (_that) {
case _ApiProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiProduct value)?  $default,){
final _that = this;
switch (_that) {
case _ApiProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String? id,  String? code, @JsonKey(name: 'product_name')  String? productName,  String? brands,  String? categories, @JsonKey(name: 'ingredients_text')  String? ingredientsText, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_small_url')  String? imageSmallUrl, @JsonKey(name: 'image_front_url')  String? imageFrontUrl,  String? quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiProduct() when $default != null:
return $default(_that.id,_that.code,_that.productName,_that.brands,_that.categories,_that.ingredientsText,_that.imageUrl,_that.imageSmallUrl,_that.imageFrontUrl,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String? id,  String? code, @JsonKey(name: 'product_name')  String? productName,  String? brands,  String? categories, @JsonKey(name: 'ingredients_text')  String? ingredientsText, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_small_url')  String? imageSmallUrl, @JsonKey(name: 'image_front_url')  String? imageFrontUrl,  String? quantity)  $default,) {final _that = this;
switch (_that) {
case _ApiProduct():
return $default(_that.id,_that.code,_that.productName,_that.brands,_that.categories,_that.ingredientsText,_that.imageUrl,_that.imageSmallUrl,_that.imageFrontUrl,_that.quantity);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String? id,  String? code, @JsonKey(name: 'product_name')  String? productName,  String? brands,  String? categories, @JsonKey(name: 'ingredients_text')  String? ingredientsText, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_small_url')  String? imageSmallUrl, @JsonKey(name: 'image_front_url')  String? imageFrontUrl,  String? quantity)?  $default,) {final _that = this;
switch (_that) {
case _ApiProduct() when $default != null:
return $default(_that.id,_that.code,_that.productName,_that.brands,_that.categories,_that.ingredientsText,_that.imageUrl,_that.imageSmallUrl,_that.imageFrontUrl,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiProduct implements ApiProduct {
  const _ApiProduct({@JsonKey(name: '_id') this.id, this.code, @JsonKey(name: 'product_name') this.productName, this.brands, this.categories, @JsonKey(name: 'ingredients_text') this.ingredientsText, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'image_small_url') this.imageSmallUrl, @JsonKey(name: 'image_front_url') this.imageFrontUrl, this.quantity});
  factory _ApiProduct.fromJson(Map<String, dynamic> json) => _$ApiProductFromJson(json);

/// Product barcode/ID (e.g., "3760346072747")
@override@JsonKey(name: '_id') final  String? id;
/// Product barcode
@override final  String? code;
/// Product name
@override@JsonKey(name: 'product_name') final  String? productName;
/// Brand name
@override final  String? brands;
/// Product categories
@override final  String? categories;
/// Raw ingredients text
@override@JsonKey(name: 'ingredients_text') final  String? ingredientsText;
/// Product image URL
@override@JsonKey(name: 'image_url') final  String? imageUrl;
/// Small product image URL
@override@JsonKey(name: 'image_small_url') final  String? imageSmallUrl;
/// Front image URL
@override@JsonKey(name: 'image_front_url') final  String? imageFrontUrl;
/// Product quantity (e.g., "250ml")
@override final  String? quantity;

/// Create a copy of ApiProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiProductCopyWith<_ApiProduct> get copyWith => __$ApiProductCopyWithImpl<_ApiProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.brands, brands) || other.brands == brands)&&(identical(other.categories, categories) || other.categories == categories)&&(identical(other.ingredientsText, ingredientsText) || other.ingredientsText == ingredientsText)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageSmallUrl, imageSmallUrl) || other.imageSmallUrl == imageSmallUrl)&&(identical(other.imageFrontUrl, imageFrontUrl) || other.imageFrontUrl == imageFrontUrl)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,productName,brands,categories,ingredientsText,imageUrl,imageSmallUrl,imageFrontUrl,quantity);

@override
String toString() {
  return 'ApiProduct(id: $id, code: $code, productName: $productName, brands: $brands, categories: $categories, ingredientsText: $ingredientsText, imageUrl: $imageUrl, imageSmallUrl: $imageSmallUrl, imageFrontUrl: $imageFrontUrl, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$ApiProductCopyWith<$Res> implements $ApiProductCopyWith<$Res> {
  factory _$ApiProductCopyWith(_ApiProduct value, $Res Function(_ApiProduct) _then) = __$ApiProductCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String? id, String? code,@JsonKey(name: 'product_name') String? productName, String? brands, String? categories,@JsonKey(name: 'ingredients_text') String? ingredientsText,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'image_small_url') String? imageSmallUrl,@JsonKey(name: 'image_front_url') String? imageFrontUrl, String? quantity
});




}
/// @nodoc
class __$ApiProductCopyWithImpl<$Res>
    implements _$ApiProductCopyWith<$Res> {
  __$ApiProductCopyWithImpl(this._self, this._then);

  final _ApiProduct _self;
  final $Res Function(_ApiProduct) _then;

/// Create a copy of ApiProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? code = freezed,Object? productName = freezed,Object? brands = freezed,Object? categories = freezed,Object? ingredientsText = freezed,Object? imageUrl = freezed,Object? imageSmallUrl = freezed,Object? imageFrontUrl = freezed,Object? quantity = freezed,}) {
  return _then(_ApiProduct(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,brands: freezed == brands ? _self.brands : brands // ignore: cast_nullable_to_non_nullable
as String?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as String?,ingredientsText: freezed == ingredientsText ? _self.ingredientsText : ingredientsText // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageSmallUrl: freezed == imageSmallUrl ? _self.imageSmallUrl : imageSmallUrl // ignore: cast_nullable_to_non_nullable
as String?,imageFrontUrl: freezed == imageFrontUrl ? _self.imageFrontUrl : imageFrontUrl // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
