import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hair_care/core/network/api_client.dart';
import 'package:smart_hair_care/core/network/models/models.dart';

part 'product_search_notifier.freezed.dart';

/// State class for product search
@freezed
sealed class ProductSearchState with _$ProductSearchState {
  const factory ProductSearchState({
    @Default([]) List<ApiProduct> products,
    @Default(false) bool isLoading,
    String? error,
    @Default('') String query,
  }) = _ProductSearchState;
}

/// Notifier for managing product search state (Riverpod 3)
///
/// Note: This uses regular Notifier instead of AsyncNotifier because
/// search requires debouncing which doesn't fit the AsyncNotifier pattern.
class ProductSearchNotifier extends Notifier<ProductSearchState> {
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 400);

  @override
  ProductSearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return const ProductSearchState();
  }

  /// Search for products with debouncing
  void search(String query) {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      state = const ProductSearchState();
      return;
    }

    state = state.copyWith(query: query, isLoading: true);

    _debounceTimer = Timer(_debounceDuration, () {
      // ignore: discarded_futures, intentionally fire-and-forget
      _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.searchBeautyProducts(
        searchTerms: query,
        pageSize: 20,
        page: 1,
      );

      state = state.copyWith(
        products: response.products,
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clears search results and query
  void clearSearch() {
    _debounceTimer?.cancel();
    state = const ProductSearchState();
  }

  /// Clears any error state
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }
}

/// Provider for product search
final productSearchProvider =
    NotifierProvider<ProductSearchNotifier, ProductSearchState>(
  ProductSearchNotifier.new,
);
