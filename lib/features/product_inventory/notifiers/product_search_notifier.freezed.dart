// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_search_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductSearchState {

 List<ApiProduct> get products; bool get isLoading; String? get error; String get query;
/// Create a copy of ProductSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSearchStateCopyWith<ProductSearchState> get copyWith => _$ProductSearchStateCopyWithImpl<ProductSearchState>(this as ProductSearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSearchState&&const DeepCollectionEquality().equals(other.products, products)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(products),isLoading,error,query);

@override
String toString() {
  return 'ProductSearchState(products: $products, isLoading: $isLoading, error: $error, query: $query)';
}


}

/// @nodoc
abstract mixin class $ProductSearchStateCopyWith<$Res>  {
  factory $ProductSearchStateCopyWith(ProductSearchState value, $Res Function(ProductSearchState) _then) = _$ProductSearchStateCopyWithImpl;
@useResult
$Res call({
 List<ApiProduct> products, bool isLoading, String? error, String query
});




}
/// @nodoc
class _$ProductSearchStateCopyWithImpl<$Res>
    implements $ProductSearchStateCopyWith<$Res> {
  _$ProductSearchStateCopyWithImpl(this._self, this._then);

  final ProductSearchState _self;
  final $Res Function(ProductSearchState) _then;

/// Create a copy of ProductSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? products = null,Object? isLoading = null,Object? error = freezed,Object? query = null,}) {
  return _then(_self.copyWith(
products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ApiProduct>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSearchState].
extension ProductSearchStatePatterns on ProductSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSearchState value)  $default,){
final _that = this;
switch (_that) {
case _ProductSearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSearchState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ApiProduct> products,  bool isLoading,  String? error,  String query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSearchState() when $default != null:
return $default(_that.products,_that.isLoading,_that.error,_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ApiProduct> products,  bool isLoading,  String? error,  String query)  $default,) {final _that = this;
switch (_that) {
case _ProductSearchState():
return $default(_that.products,_that.isLoading,_that.error,_that.query);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ApiProduct> products,  bool isLoading,  String? error,  String query)?  $default,) {final _that = this;
switch (_that) {
case _ProductSearchState() when $default != null:
return $default(_that.products,_that.isLoading,_that.error,_that.query);case _:
  return null;

}
}

}

/// @nodoc


class _ProductSearchState implements ProductSearchState {
  const _ProductSearchState({final  List<ApiProduct> products = const [], this.isLoading = false, this.error, this.query = ''}): _products = products;
  

 final  List<ApiProduct> _products;
@override@JsonKey() List<ApiProduct> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@override@JsonKey() final  bool isLoading;
@override final  String? error;
@override@JsonKey() final  String query;

/// Create a copy of ProductSearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSearchStateCopyWith<_ProductSearchState> get copyWith => __$ProductSearchStateCopyWithImpl<_ProductSearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSearchState&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products),isLoading,error,query);

@override
String toString() {
  return 'ProductSearchState(products: $products, isLoading: $isLoading, error: $error, query: $query)';
}


}

/// @nodoc
abstract mixin class _$ProductSearchStateCopyWith<$Res> implements $ProductSearchStateCopyWith<$Res> {
  factory _$ProductSearchStateCopyWith(_ProductSearchState value, $Res Function(_ProductSearchState) _then) = __$ProductSearchStateCopyWithImpl;
@override @useResult
$Res call({
 List<ApiProduct> products, bool isLoading, String? error, String query
});




}
/// @nodoc
class __$ProductSearchStateCopyWithImpl<$Res>
    implements _$ProductSearchStateCopyWith<$Res> {
  __$ProductSearchStateCopyWithImpl(this._self, this._then);

  final _ProductSearchState _self;
  final $Res Function(_ProductSearchState) _then;

/// Create a copy of ProductSearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? products = null,Object? isLoading = null,Object? error = freezed,Object? query = null,}) {
  return _then(_ProductSearchState(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ApiProduct>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
