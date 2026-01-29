/// Product categories for hair care products
enum ProductCategory {
  shampoo('shampoo', 'Shampoo'),
  conditioner('conditioner', 'Conditioner'),
  deepConditioner('deep_conditioner', 'Deep Conditioner'),
  leaveIn('leave_in', 'Leave-In'),
  oil('oil', 'Oil'),
  cream('cream', 'Cream'),
  gel('gel', 'Gel'),
  mousse('mousse', 'Mousse'),
  spray('spray', 'Spray'),
  treatment('treatment', 'Treatment'),
  other('other', 'Other');

  const ProductCategory(this.value, this.displayName);

  /// The value stored in the database
  final String value;

  /// Human-readable display name
  final String displayName;

  /// Get a [ProductCategory] from its stored [value], or [other] if not found
  static ProductCategory fromValue(String? value) {
    if (value == null) return ProductCategory.shampoo;
    return ProductCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ProductCategory.other,
    );
  }
}
