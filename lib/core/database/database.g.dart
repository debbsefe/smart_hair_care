// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientsMeta = const VerificationMeta(
    'ingredients',
  );
  @override
  late final GeneratedColumn<String> ingredients = GeneratedColumn<String>(
    'ingredients',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    brand,
    category,
    ingredients,
    rating,
    isFavorite,
    notes,
    imageUrl,
    purchaseDate,
    expiryDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('ingredients')) {
      context.handle(
        _ingredientsMeta,
        ingredients.isAcceptableOrUnknown(
          data['ingredients']!,
          _ingredientsMeta,
        ),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      ingredients: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredients'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String? brand;
  final String category;
  final String? ingredients;
  final double? rating;
  final bool isFavorite;
  final String? notes;
  final String? imageUrl;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product({
    required this.id,
    required this.name,
    this.brand,
    required this.category,
    this.ingredients,
    this.rating,
    required this.isFavorite,
    this.notes,
    this.imageUrl,
    this.purchaseDate,
    this.expiryDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || ingredients != null) {
      map['ingredients'] = Variable<String>(ingredients);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      category: Value(category),
      ingredients: ingredients == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredients),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      isFavorite: Value(isFavorite),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      category: serializer.fromJson<String>(json['category']),
      ingredients: serializer.fromJson<String?>(json['ingredients']),
      rating: serializer.fromJson<double?>(json['rating']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      notes: serializer.fromJson<String?>(json['notes']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'category': serializer.toJson<String>(category),
      'ingredients': serializer.toJson<String?>(ingredients),
      'rating': serializer.toJson<double?>(rating),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'notes': serializer.toJson<String?>(notes),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith({
    int? id,
    String? name,
    Value<String?> brand = const Value.absent(),
    String? category,
    Value<String?> ingredients = const Value.absent(),
    Value<double?> rating = const Value.absent(),
    bool? isFavorite,
    Value<String?> notes = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<DateTime?> purchaseDate = const Value.absent(),
    Value<DateTime?> expiryDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    category: category ?? this.category,
    ingredients: ingredients.present ? ingredients.value : this.ingredients,
    rating: rating.present ? rating.value : this.rating,
    isFavorite: isFavorite ?? this.isFavorite,
    notes: notes.present ? notes.value : this.notes,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    purchaseDate: purchaseDate.present ? purchaseDate.value : this.purchaseDate,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      category: data.category.present ? data.category.value : this.category,
      ingredients: data.ingredients.present
          ? data.ingredients.value
          : this.ingredients,
      rating: data.rating.present ? data.rating.value : this.rating,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      notes: data.notes.present ? data.notes.value : this.notes,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('ingredients: $ingredients, ')
          ..write('rating: $rating, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('notes: $notes, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    brand,
    category,
    ingredients,
    rating,
    isFavorite,
    notes,
    imageUrl,
    purchaseDate,
    expiryDate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.category == this.category &&
          other.ingredients == this.ingredients &&
          other.rating == this.rating &&
          other.isFavorite == this.isFavorite &&
          other.notes == this.notes &&
          other.imageUrl == this.imageUrl &&
          other.purchaseDate == this.purchaseDate &&
          other.expiryDate == this.expiryDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String> category;
  final Value<String?> ingredients;
  final Value<double?> rating;
  final Value<bool> isFavorite;
  final Value<String?> notes;
  final Value<String?> imageUrl;
  final Value<DateTime?> purchaseDate;
  final Value<DateTime?> expiryDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.rating = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.notes = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    required String category,
    this.ingredients = const Value.absent(),
    this.rating = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.notes = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       category = Value(category);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? category,
    Expression<String>? ingredients,
    Expression<double>? rating,
    Expression<bool>? isFavorite,
    Expression<String>? notes,
    Expression<String>? imageUrl,
    Expression<DateTime>? purchaseDate,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (ingredients != null) 'ingredients': ingredients,
      if (rating != null) 'rating': rating,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (notes != null) 'notes': notes,
      if (imageUrl != null) 'image_url': imageUrl,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? brand,
    Value<String>? category,
    Value<String?>? ingredients,
    Value<double?>? rating,
    Value<bool>? isFavorite,
    Value<String?>? notes,
    Value<String?>? imageUrl,
    Value<DateTime?>? purchaseDate,
    Value<DateTime?>? expiryDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (ingredients.present) {
      map['ingredients'] = Variable<String>(ingredients.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('ingredients: $ingredients, ')
          ..write('rating: $rating, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('notes: $notes, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyLogsTable extends DailyLogs
    with TableInfo<$DailyLogsTable, DailyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineTypeMeta = const VerificationMeta(
    'routineType',
  );
  @override
  late final GeneratedColumn<String> routineType = GeneratedColumn<String>(
    'routine_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productsUsedMeta = const VerificationMeta(
    'productsUsed',
  );
  @override
  late final GeneratedColumn<String> productsUsed = GeneratedColumn<String>(
    'products_used',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _techniquesMeta = const VerificationMeta(
    'techniques',
  );
  @override
  late final GeneratedColumn<String> techniques = GeneratedColumn<String>(
    'techniques',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hairConditionRatingMeta =
      const VerificationMeta('hairConditionRating');
  @override
  late final GeneratedColumn<int> hairConditionRating = GeneratedColumn<int>(
    'hair_condition_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherMeta = const VerificationMeta(
    'weather',
  );
  @override
  late final GeneratedColumn<String> weather = GeneratedColumn<String>(
    'weather',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _humidityLevelMeta = const VerificationMeta(
    'humidityLevel',
  );
  @override
  late final GeneratedColumn<int> humidityLevel = GeneratedColumn<int>(
    'humidity_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrlsMeta = const VerificationMeta(
    'photoUrls',
  );
  @override
  late final GeneratedColumn<String> photoUrls = GeneratedColumn<String>(
    'photo_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    routineType,
    productsUsed,
    techniques,
    hairConditionRating,
    weather,
    humidityLevel,
    notes,
    photoUrls,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('routine_type')) {
      context.handle(
        _routineTypeMeta,
        routineType.isAcceptableOrUnknown(
          data['routine_type']!,
          _routineTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_routineTypeMeta);
    }
    if (data.containsKey('products_used')) {
      context.handle(
        _productsUsedMeta,
        productsUsed.isAcceptableOrUnknown(
          data['products_used']!,
          _productsUsedMeta,
        ),
      );
    }
    if (data.containsKey('techniques')) {
      context.handle(
        _techniquesMeta,
        techniques.isAcceptableOrUnknown(data['techniques']!, _techniquesMeta),
      );
    }
    if (data.containsKey('hair_condition_rating')) {
      context.handle(
        _hairConditionRatingMeta,
        hairConditionRating.isAcceptableOrUnknown(
          data['hair_condition_rating']!,
          _hairConditionRatingMeta,
        ),
      );
    }
    if (data.containsKey('weather')) {
      context.handle(
        _weatherMeta,
        weather.isAcceptableOrUnknown(data['weather']!, _weatherMeta),
      );
    }
    if (data.containsKey('humidity_level')) {
      context.handle(
        _humidityLevelMeta,
        humidityLevel.isAcceptableOrUnknown(
          data['humidity_level']!,
          _humidityLevelMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('photo_urls')) {
      context.handle(
        _photoUrlsMeta,
        photoUrls.isAcceptableOrUnknown(data['photo_urls']!, _photoUrlsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      routineType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_type'],
      )!,
      productsUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}products_used'],
      ),
      techniques: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}techniques'],
      ),
      hairConditionRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hair_condition_rating'],
      ),
      weather: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weather'],
      ),
      humidityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}humidity_level'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      photoUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_urls'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DailyLogsTable createAlias(String alias) {
    return $DailyLogsTable(attachedDatabase, alias);
  }
}

class DailyLog extends DataClass implements Insertable<DailyLog> {
  final int id;
  final DateTime date;
  final String routineType;
  final String? productsUsed;
  final String? techniques;
  final int? hairConditionRating;
  final String? weather;
  final int? humidityLevel;
  final String? notes;
  final String? photoUrls;
  final DateTime createdAt;
  const DailyLog({
    required this.id,
    required this.date,
    required this.routineType,
    this.productsUsed,
    this.techniques,
    this.hairConditionRating,
    this.weather,
    this.humidityLevel,
    this.notes,
    this.photoUrls,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['routine_type'] = Variable<String>(routineType);
    if (!nullToAbsent || productsUsed != null) {
      map['products_used'] = Variable<String>(productsUsed);
    }
    if (!nullToAbsent || techniques != null) {
      map['techniques'] = Variable<String>(techniques);
    }
    if (!nullToAbsent || hairConditionRating != null) {
      map['hair_condition_rating'] = Variable<int>(hairConditionRating);
    }
    if (!nullToAbsent || weather != null) {
      map['weather'] = Variable<String>(weather);
    }
    if (!nullToAbsent || humidityLevel != null) {
      map['humidity_level'] = Variable<int>(humidityLevel);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoUrls != null) {
      map['photo_urls'] = Variable<String>(photoUrls);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailyLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyLogsCompanion(
      id: Value(id),
      date: Value(date),
      routineType: Value(routineType),
      productsUsed: productsUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(productsUsed),
      techniques: techniques == null && nullToAbsent
          ? const Value.absent()
          : Value(techniques),
      hairConditionRating: hairConditionRating == null && nullToAbsent
          ? const Value.absent()
          : Value(hairConditionRating),
      weather: weather == null && nullToAbsent
          ? const Value.absent()
          : Value(weather),
      humidityLevel: humidityLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(humidityLevel),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      photoUrls: photoUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrls),
      createdAt: Value(createdAt),
    );
  }

  factory DailyLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      routineType: serializer.fromJson<String>(json['routineType']),
      productsUsed: serializer.fromJson<String?>(json['productsUsed']),
      techniques: serializer.fromJson<String?>(json['techniques']),
      hairConditionRating: serializer.fromJson<int?>(
        json['hairConditionRating'],
      ),
      weather: serializer.fromJson<String?>(json['weather']),
      humidityLevel: serializer.fromJson<int?>(json['humidityLevel']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoUrls: serializer.fromJson<String?>(json['photoUrls']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'routineType': serializer.toJson<String>(routineType),
      'productsUsed': serializer.toJson<String?>(productsUsed),
      'techniques': serializer.toJson<String?>(techniques),
      'hairConditionRating': serializer.toJson<int?>(hairConditionRating),
      'weather': serializer.toJson<String?>(weather),
      'humidityLevel': serializer.toJson<int?>(humidityLevel),
      'notes': serializer.toJson<String?>(notes),
      'photoUrls': serializer.toJson<String?>(photoUrls),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailyLog copyWith({
    int? id,
    DateTime? date,
    String? routineType,
    Value<String?> productsUsed = const Value.absent(),
    Value<String?> techniques = const Value.absent(),
    Value<int?> hairConditionRating = const Value.absent(),
    Value<String?> weather = const Value.absent(),
    Value<int?> humidityLevel = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> photoUrls = const Value.absent(),
    DateTime? createdAt,
  }) => DailyLog(
    id: id ?? this.id,
    date: date ?? this.date,
    routineType: routineType ?? this.routineType,
    productsUsed: productsUsed.present ? productsUsed.value : this.productsUsed,
    techniques: techniques.present ? techniques.value : this.techniques,
    hairConditionRating: hairConditionRating.present
        ? hairConditionRating.value
        : this.hairConditionRating,
    weather: weather.present ? weather.value : this.weather,
    humidityLevel: humidityLevel.present
        ? humidityLevel.value
        : this.humidityLevel,
    notes: notes.present ? notes.value : this.notes,
    photoUrls: photoUrls.present ? photoUrls.value : this.photoUrls,
    createdAt: createdAt ?? this.createdAt,
  );
  DailyLog copyWithCompanion(DailyLogsCompanion data) {
    return DailyLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      routineType: data.routineType.present
          ? data.routineType.value
          : this.routineType,
      productsUsed: data.productsUsed.present
          ? data.productsUsed.value
          : this.productsUsed,
      techniques: data.techniques.present
          ? data.techniques.value
          : this.techniques,
      hairConditionRating: data.hairConditionRating.present
          ? data.hairConditionRating.value
          : this.hairConditionRating,
      weather: data.weather.present ? data.weather.value : this.weather,
      humidityLevel: data.humidityLevel.present
          ? data.humidityLevel.value
          : this.humidityLevel,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoUrls: data.photoUrls.present ? data.photoUrls.value : this.photoUrls,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('routineType: $routineType, ')
          ..write('productsUsed: $productsUsed, ')
          ..write('techniques: $techniques, ')
          ..write('hairConditionRating: $hairConditionRating, ')
          ..write('weather: $weather, ')
          ..write('humidityLevel: $humidityLevel, ')
          ..write('notes: $notes, ')
          ..write('photoUrls: $photoUrls, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    routineType,
    productsUsed,
    techniques,
    hairConditionRating,
    weather,
    humidityLevel,
    notes,
    photoUrls,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.routineType == this.routineType &&
          other.productsUsed == this.productsUsed &&
          other.techniques == this.techniques &&
          other.hairConditionRating == this.hairConditionRating &&
          other.weather == this.weather &&
          other.humidityLevel == this.humidityLevel &&
          other.notes == this.notes &&
          other.photoUrls == this.photoUrls &&
          other.createdAt == this.createdAt);
}

class DailyLogsCompanion extends UpdateCompanion<DailyLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> routineType;
  final Value<String?> productsUsed;
  final Value<String?> techniques;
  final Value<int?> hairConditionRating;
  final Value<String?> weather;
  final Value<int?> humidityLevel;
  final Value<String?> notes;
  final Value<String?> photoUrls;
  final Value<DateTime> createdAt;
  const DailyLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.routineType = const Value.absent(),
    this.productsUsed = const Value.absent(),
    this.techniques = const Value.absent(),
    this.hairConditionRating = const Value.absent(),
    this.weather = const Value.absent(),
    this.humidityLevel = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoUrls = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailyLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String routineType,
    this.productsUsed = const Value.absent(),
    this.techniques = const Value.absent(),
    this.hairConditionRating = const Value.absent(),
    this.weather = const Value.absent(),
    this.humidityLevel = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoUrls = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date),
       routineType = Value(routineType);
  static Insertable<DailyLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? routineType,
    Expression<String>? productsUsed,
    Expression<String>? techniques,
    Expression<int>? hairConditionRating,
    Expression<String>? weather,
    Expression<int>? humidityLevel,
    Expression<String>? notes,
    Expression<String>? photoUrls,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (routineType != null) 'routine_type': routineType,
      if (productsUsed != null) 'products_used': productsUsed,
      if (techniques != null) 'techniques': techniques,
      if (hairConditionRating != null)
        'hair_condition_rating': hairConditionRating,
      if (weather != null) 'weather': weather,
      if (humidityLevel != null) 'humidity_level': humidityLevel,
      if (notes != null) 'notes': notes,
      if (photoUrls != null) 'photo_urls': photoUrls,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailyLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? routineType,
    Value<String?>? productsUsed,
    Value<String?>? techniques,
    Value<int?>? hairConditionRating,
    Value<String?>? weather,
    Value<int?>? humidityLevel,
    Value<String?>? notes,
    Value<String?>? photoUrls,
    Value<DateTime>? createdAt,
  }) {
    return DailyLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      routineType: routineType ?? this.routineType,
      productsUsed: productsUsed ?? this.productsUsed,
      techniques: techniques ?? this.techniques,
      hairConditionRating: hairConditionRating ?? this.hairConditionRating,
      weather: weather ?? this.weather,
      humidityLevel: humidityLevel ?? this.humidityLevel,
      notes: notes ?? this.notes,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (routineType.present) {
      map['routine_type'] = Variable<String>(routineType.value);
    }
    if (productsUsed.present) {
      map['products_used'] = Variable<String>(productsUsed.value);
    }
    if (techniques.present) {
      map['techniques'] = Variable<String>(techniques.value);
    }
    if (hairConditionRating.present) {
      map['hair_condition_rating'] = Variable<int>(hairConditionRating.value);
    }
    if (weather.present) {
      map['weather'] = Variable<String>(weather.value);
    }
    if (humidityLevel.present) {
      map['humidity_level'] = Variable<int>(humidityLevel.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoUrls.present) {
      map['photo_urls'] = Variable<String>(photoUrls.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('routineType: $routineType, ')
          ..write('productsUsed: $productsUsed, ')
          ..write('techniques: $techniques, ')
          ..write('hairConditionRating: $hairConditionRating, ')
          ..write('weather: $weather, ')
          ..write('humidityLevel: $humidityLevel, ')
          ..write('notes: $notes, ')
          ..write('photoUrls: $photoUrls, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HairProfilesTable extends HairProfiles
    with TableInfo<$HairProfilesTable, HairProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HairProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryTypeMeta = const VerificationMeta(
    'primaryType',
  );
  @override
  late final GeneratedColumn<String> primaryType = GeneratedColumn<String>(
    'primary_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  specificPatterns = GeneratedColumn<String>(
    'specific_patterns',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($HairProfilesTable.$converterspecificPatterns);
  static const VerificationMeta _isMultiTexturedMeta = const VerificationMeta(
    'isMultiTextured',
  );
  @override
  late final GeneratedColumn<bool> isMultiTextured = GeneratedColumn<bool>(
    'is_multi_textured',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_multi_textured" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _porosityMeta = const VerificationMeta(
    'porosity',
  );
  @override
  late final GeneratedColumn<String> porosity = GeneratedColumn<String>(
    'porosity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _densityMeta = const VerificationMeta(
    'density',
  );
  @override
  late final GeneratedColumn<String> density = GeneratedColumn<String>(
    'density',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thicknessMeta = const VerificationMeta(
    'thickness',
  );
  @override
  late final GeneratedColumn<String> thickness = GeneratedColumn<String>(
    'thickness',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scalpTypeMeta = const VerificationMeta(
    'scalpType',
  );
  @override
  late final GeneratedColumn<String> scalpType = GeneratedColumn<String>(
    'scalp_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hairLengthMeta = const VerificationMeta(
    'hairLength',
  );
  @override
  late final GeneratedColumn<double> hairLength = GeneratedColumn<double>(
    'hair_length',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _concernsMeta = const VerificationMeta(
    'concerns',
  );
  @override
  late final GeneratedColumn<String> concerns = GeneratedColumn<String>(
    'concerns',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalsMeta = const VerificationMeta('goals');
  @override
  late final GeneratedColumn<String> goals = GeneratedColumn<String>(
    'goals',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isColorTreatedMeta = const VerificationMeta(
    'isColorTreated',
  );
  @override
  late final GeneratedColumn<bool> isColorTreated = GeneratedColumn<bool>(
    'is_color_treated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_color_treated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isHeatDamagedMeta = const VerificationMeta(
    'isHeatDamaged',
  );
  @override
  late final GeneratedColumn<bool> isHeatDamaged = GeneratedColumn<bool>(
    'is_heat_damaged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_heat_damaged" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    primaryType,
    specificPatterns,
    isMultiTextured,
    porosity,
    density,
    thickness,
    scalpType,
    hairLength,
    concerns,
    goals,
    isColorTreated,
    isHeatDamaged,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hair_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<HairProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('primary_type')) {
      context.handle(
        _primaryTypeMeta,
        primaryType.isAcceptableOrUnknown(
          data['primary_type']!,
          _primaryTypeMeta,
        ),
      );
    }
    if (data.containsKey('is_multi_textured')) {
      context.handle(
        _isMultiTexturedMeta,
        isMultiTextured.isAcceptableOrUnknown(
          data['is_multi_textured']!,
          _isMultiTexturedMeta,
        ),
      );
    }
    if (data.containsKey('porosity')) {
      context.handle(
        _porosityMeta,
        porosity.isAcceptableOrUnknown(data['porosity']!, _porosityMeta),
      );
    }
    if (data.containsKey('density')) {
      context.handle(
        _densityMeta,
        density.isAcceptableOrUnknown(data['density']!, _densityMeta),
      );
    }
    if (data.containsKey('thickness')) {
      context.handle(
        _thicknessMeta,
        thickness.isAcceptableOrUnknown(data['thickness']!, _thicknessMeta),
      );
    }
    if (data.containsKey('scalp_type')) {
      context.handle(
        _scalpTypeMeta,
        scalpType.isAcceptableOrUnknown(data['scalp_type']!, _scalpTypeMeta),
      );
    }
    if (data.containsKey('hair_length')) {
      context.handle(
        _hairLengthMeta,
        hairLength.isAcceptableOrUnknown(data['hair_length']!, _hairLengthMeta),
      );
    }
    if (data.containsKey('concerns')) {
      context.handle(
        _concernsMeta,
        concerns.isAcceptableOrUnknown(data['concerns']!, _concernsMeta),
      );
    }
    if (data.containsKey('goals')) {
      context.handle(
        _goalsMeta,
        goals.isAcceptableOrUnknown(data['goals']!, _goalsMeta),
      );
    }
    if (data.containsKey('is_color_treated')) {
      context.handle(
        _isColorTreatedMeta,
        isColorTreated.isAcceptableOrUnknown(
          data['is_color_treated']!,
          _isColorTreatedMeta,
        ),
      );
    }
    if (data.containsKey('is_heat_damaged')) {
      context.handle(
        _isHeatDamagedMeta,
        isHeatDamaged.isAcceptableOrUnknown(
          data['is_heat_damaged']!,
          _isHeatDamagedMeta,
        ),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HairProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HairProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      primaryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_type'],
      ),
      specificPatterns: $HairProfilesTable.$converterspecificPatterns.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}specific_patterns'],
        )!,
      ),
      isMultiTextured: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_multi_textured'],
      )!,
      porosity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}porosity'],
      ),
      density: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}density'],
      ),
      thickness: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thickness'],
      ),
      scalpType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scalp_type'],
      ),
      hairLength: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hair_length'],
      ),
      concerns: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concerns'],
      ),
      goals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goals'],
      ),
      isColorTreated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_color_treated'],
      )!,
      isHeatDamaged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_heat_damaged'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $HairProfilesTable createAlias(String alias) {
    return $HairProfilesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterspecificPatterns =
      const SpecificPatternsConverter();
}

class HairProfile extends DataClass implements Insertable<HairProfile> {
  final int id;
  final String? name;
  final String? primaryType;
  final List<String> specificPatterns;
  final bool isMultiTextured;
  final String? porosity;
  final String? density;
  final String? thickness;
  final String? scalpType;
  final double? hairLength;
  final String? concerns;
  final String? goals;
  final bool isColorTreated;
  final bool isHeatDamaged;
  final DateTime lastUpdated;
  const HairProfile({
    required this.id,
    this.name,
    this.primaryType,
    required this.specificPatterns,
    required this.isMultiTextured,
    this.porosity,
    this.density,
    this.thickness,
    this.scalpType,
    this.hairLength,
    this.concerns,
    this.goals,
    required this.isColorTreated,
    required this.isHeatDamaged,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || primaryType != null) {
      map['primary_type'] = Variable<String>(primaryType);
    }
    {
      map['specific_patterns'] = Variable<String>(
        $HairProfilesTable.$converterspecificPatterns.toSql(specificPatterns),
      );
    }
    map['is_multi_textured'] = Variable<bool>(isMultiTextured);
    if (!nullToAbsent || porosity != null) {
      map['porosity'] = Variable<String>(porosity);
    }
    if (!nullToAbsent || density != null) {
      map['density'] = Variable<String>(density);
    }
    if (!nullToAbsent || thickness != null) {
      map['thickness'] = Variable<String>(thickness);
    }
    if (!nullToAbsent || scalpType != null) {
      map['scalp_type'] = Variable<String>(scalpType);
    }
    if (!nullToAbsent || hairLength != null) {
      map['hair_length'] = Variable<double>(hairLength);
    }
    if (!nullToAbsent || concerns != null) {
      map['concerns'] = Variable<String>(concerns);
    }
    if (!nullToAbsent || goals != null) {
      map['goals'] = Variable<String>(goals);
    }
    map['is_color_treated'] = Variable<bool>(isColorTreated);
    map['is_heat_damaged'] = Variable<bool>(isHeatDamaged);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  HairProfilesCompanion toCompanion(bool nullToAbsent) {
    return HairProfilesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      primaryType: primaryType == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryType),
      specificPatterns: Value(specificPatterns),
      isMultiTextured: Value(isMultiTextured),
      porosity: porosity == null && nullToAbsent
          ? const Value.absent()
          : Value(porosity),
      density: density == null && nullToAbsent
          ? const Value.absent()
          : Value(density),
      thickness: thickness == null && nullToAbsent
          ? const Value.absent()
          : Value(thickness),
      scalpType: scalpType == null && nullToAbsent
          ? const Value.absent()
          : Value(scalpType),
      hairLength: hairLength == null && nullToAbsent
          ? const Value.absent()
          : Value(hairLength),
      concerns: concerns == null && nullToAbsent
          ? const Value.absent()
          : Value(concerns),
      goals: goals == null && nullToAbsent
          ? const Value.absent()
          : Value(goals),
      isColorTreated: Value(isColorTreated),
      isHeatDamaged: Value(isHeatDamaged),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory HairProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HairProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      primaryType: serializer.fromJson<String?>(json['primaryType']),
      specificPatterns: serializer.fromJson<List<String>>(
        json['specificPatterns'],
      ),
      isMultiTextured: serializer.fromJson<bool>(json['isMultiTextured']),
      porosity: serializer.fromJson<String?>(json['porosity']),
      density: serializer.fromJson<String?>(json['density']),
      thickness: serializer.fromJson<String?>(json['thickness']),
      scalpType: serializer.fromJson<String?>(json['scalpType']),
      hairLength: serializer.fromJson<double?>(json['hairLength']),
      concerns: serializer.fromJson<String?>(json['concerns']),
      goals: serializer.fromJson<String?>(json['goals']),
      isColorTreated: serializer.fromJson<bool>(json['isColorTreated']),
      isHeatDamaged: serializer.fromJson<bool>(json['isHeatDamaged']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'primaryType': serializer.toJson<String?>(primaryType),
      'specificPatterns': serializer.toJson<List<String>>(specificPatterns),
      'isMultiTextured': serializer.toJson<bool>(isMultiTextured),
      'porosity': serializer.toJson<String?>(porosity),
      'density': serializer.toJson<String?>(density),
      'thickness': serializer.toJson<String?>(thickness),
      'scalpType': serializer.toJson<String?>(scalpType),
      'hairLength': serializer.toJson<double?>(hairLength),
      'concerns': serializer.toJson<String?>(concerns),
      'goals': serializer.toJson<String?>(goals),
      'isColorTreated': serializer.toJson<bool>(isColorTreated),
      'isHeatDamaged': serializer.toJson<bool>(isHeatDamaged),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  HairProfile copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    Value<String?> primaryType = const Value.absent(),
    List<String>? specificPatterns,
    bool? isMultiTextured,
    Value<String?> porosity = const Value.absent(),
    Value<String?> density = const Value.absent(),
    Value<String?> thickness = const Value.absent(),
    Value<String?> scalpType = const Value.absent(),
    Value<double?> hairLength = const Value.absent(),
    Value<String?> concerns = const Value.absent(),
    Value<String?> goals = const Value.absent(),
    bool? isColorTreated,
    bool? isHeatDamaged,
    DateTime? lastUpdated,
  }) => HairProfile(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    primaryType: primaryType.present ? primaryType.value : this.primaryType,
    specificPatterns: specificPatterns ?? this.specificPatterns,
    isMultiTextured: isMultiTextured ?? this.isMultiTextured,
    porosity: porosity.present ? porosity.value : this.porosity,
    density: density.present ? density.value : this.density,
    thickness: thickness.present ? thickness.value : this.thickness,
    scalpType: scalpType.present ? scalpType.value : this.scalpType,
    hairLength: hairLength.present ? hairLength.value : this.hairLength,
    concerns: concerns.present ? concerns.value : this.concerns,
    goals: goals.present ? goals.value : this.goals,
    isColorTreated: isColorTreated ?? this.isColorTreated,
    isHeatDamaged: isHeatDamaged ?? this.isHeatDamaged,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  HairProfile copyWithCompanion(HairProfilesCompanion data) {
    return HairProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      primaryType: data.primaryType.present
          ? data.primaryType.value
          : this.primaryType,
      specificPatterns: data.specificPatterns.present
          ? data.specificPatterns.value
          : this.specificPatterns,
      isMultiTextured: data.isMultiTextured.present
          ? data.isMultiTextured.value
          : this.isMultiTextured,
      porosity: data.porosity.present ? data.porosity.value : this.porosity,
      density: data.density.present ? data.density.value : this.density,
      thickness: data.thickness.present ? data.thickness.value : this.thickness,
      scalpType: data.scalpType.present ? data.scalpType.value : this.scalpType,
      hairLength: data.hairLength.present
          ? data.hairLength.value
          : this.hairLength,
      concerns: data.concerns.present ? data.concerns.value : this.concerns,
      goals: data.goals.present ? data.goals.value : this.goals,
      isColorTreated: data.isColorTreated.present
          ? data.isColorTreated.value
          : this.isColorTreated,
      isHeatDamaged: data.isHeatDamaged.present
          ? data.isHeatDamaged.value
          : this.isHeatDamaged,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HairProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryType: $primaryType, ')
          ..write('specificPatterns: $specificPatterns, ')
          ..write('isMultiTextured: $isMultiTextured, ')
          ..write('porosity: $porosity, ')
          ..write('density: $density, ')
          ..write('thickness: $thickness, ')
          ..write('scalpType: $scalpType, ')
          ..write('hairLength: $hairLength, ')
          ..write('concerns: $concerns, ')
          ..write('goals: $goals, ')
          ..write('isColorTreated: $isColorTreated, ')
          ..write('isHeatDamaged: $isHeatDamaged, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    primaryType,
    specificPatterns,
    isMultiTextured,
    porosity,
    density,
    thickness,
    scalpType,
    hairLength,
    concerns,
    goals,
    isColorTreated,
    isHeatDamaged,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HairProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.primaryType == this.primaryType &&
          other.specificPatterns == this.specificPatterns &&
          other.isMultiTextured == this.isMultiTextured &&
          other.porosity == this.porosity &&
          other.density == this.density &&
          other.thickness == this.thickness &&
          other.scalpType == this.scalpType &&
          other.hairLength == this.hairLength &&
          other.concerns == this.concerns &&
          other.goals == this.goals &&
          other.isColorTreated == this.isColorTreated &&
          other.isHeatDamaged == this.isHeatDamaged &&
          other.lastUpdated == this.lastUpdated);
}

class HairProfilesCompanion extends UpdateCompanion<HairProfile> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> primaryType;
  final Value<List<String>> specificPatterns;
  final Value<bool> isMultiTextured;
  final Value<String?> porosity;
  final Value<String?> density;
  final Value<String?> thickness;
  final Value<String?> scalpType;
  final Value<double?> hairLength;
  final Value<String?> concerns;
  final Value<String?> goals;
  final Value<bool> isColorTreated;
  final Value<bool> isHeatDamaged;
  final Value<DateTime> lastUpdated;
  const HairProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.primaryType = const Value.absent(),
    this.specificPatterns = const Value.absent(),
    this.isMultiTextured = const Value.absent(),
    this.porosity = const Value.absent(),
    this.density = const Value.absent(),
    this.thickness = const Value.absent(),
    this.scalpType = const Value.absent(),
    this.hairLength = const Value.absent(),
    this.concerns = const Value.absent(),
    this.goals = const Value.absent(),
    this.isColorTreated = const Value.absent(),
    this.isHeatDamaged = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  HairProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.primaryType = const Value.absent(),
    this.specificPatterns = const Value.absent(),
    this.isMultiTextured = const Value.absent(),
    this.porosity = const Value.absent(),
    this.density = const Value.absent(),
    this.thickness = const Value.absent(),
    this.scalpType = const Value.absent(),
    this.hairLength = const Value.absent(),
    this.concerns = const Value.absent(),
    this.goals = const Value.absent(),
    this.isColorTreated = const Value.absent(),
    this.isHeatDamaged = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  static Insertable<HairProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? primaryType,
    Expression<String>? specificPatterns,
    Expression<bool>? isMultiTextured,
    Expression<String>? porosity,
    Expression<String>? density,
    Expression<String>? thickness,
    Expression<String>? scalpType,
    Expression<double>? hairLength,
    Expression<String>? concerns,
    Expression<String>? goals,
    Expression<bool>? isColorTreated,
    Expression<bool>? isHeatDamaged,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (primaryType != null) 'primary_type': primaryType,
      if (specificPatterns != null) 'specific_patterns': specificPatterns,
      if (isMultiTextured != null) 'is_multi_textured': isMultiTextured,
      if (porosity != null) 'porosity': porosity,
      if (density != null) 'density': density,
      if (thickness != null) 'thickness': thickness,
      if (scalpType != null) 'scalp_type': scalpType,
      if (hairLength != null) 'hair_length': hairLength,
      if (concerns != null) 'concerns': concerns,
      if (goals != null) 'goals': goals,
      if (isColorTreated != null) 'is_color_treated': isColorTreated,
      if (isHeatDamaged != null) 'is_heat_damaged': isHeatDamaged,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  HairProfilesCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<String?>? primaryType,
    Value<List<String>>? specificPatterns,
    Value<bool>? isMultiTextured,
    Value<String?>? porosity,
    Value<String?>? density,
    Value<String?>? thickness,
    Value<String?>? scalpType,
    Value<double?>? hairLength,
    Value<String?>? concerns,
    Value<String?>? goals,
    Value<bool>? isColorTreated,
    Value<bool>? isHeatDamaged,
    Value<DateTime>? lastUpdated,
  }) {
    return HairProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryType: primaryType ?? this.primaryType,
      specificPatterns: specificPatterns ?? this.specificPatterns,
      isMultiTextured: isMultiTextured ?? this.isMultiTextured,
      porosity: porosity ?? this.porosity,
      density: density ?? this.density,
      thickness: thickness ?? this.thickness,
      scalpType: scalpType ?? this.scalpType,
      hairLength: hairLength ?? this.hairLength,
      concerns: concerns ?? this.concerns,
      goals: goals ?? this.goals,
      isColorTreated: isColorTreated ?? this.isColorTreated,
      isHeatDamaged: isHeatDamaged ?? this.isHeatDamaged,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (primaryType.present) {
      map['primary_type'] = Variable<String>(primaryType.value);
    }
    if (specificPatterns.present) {
      map['specific_patterns'] = Variable<String>(
        $HairProfilesTable.$converterspecificPatterns.toSql(
          specificPatterns.value,
        ),
      );
    }
    if (isMultiTextured.present) {
      map['is_multi_textured'] = Variable<bool>(isMultiTextured.value);
    }
    if (porosity.present) {
      map['porosity'] = Variable<String>(porosity.value);
    }
    if (density.present) {
      map['density'] = Variable<String>(density.value);
    }
    if (thickness.present) {
      map['thickness'] = Variable<String>(thickness.value);
    }
    if (scalpType.present) {
      map['scalp_type'] = Variable<String>(scalpType.value);
    }
    if (hairLength.present) {
      map['hair_length'] = Variable<double>(hairLength.value);
    }
    if (concerns.present) {
      map['concerns'] = Variable<String>(concerns.value);
    }
    if (goals.present) {
      map['goals'] = Variable<String>(goals.value);
    }
    if (isColorTreated.present) {
      map['is_color_treated'] = Variable<bool>(isColorTreated.value);
    }
    if (isHeatDamaged.present) {
      map['is_heat_damaged'] = Variable<bool>(isHeatDamaged.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HairProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryType: $primaryType, ')
          ..write('specificPatterns: $specificPatterns, ')
          ..write('isMultiTextured: $isMultiTextured, ')
          ..write('porosity: $porosity, ')
          ..write('density: $density, ')
          ..write('thickness: $thickness, ')
          ..write('scalpType: $scalpType, ')
          ..write('hairLength: $hairLength, ')
          ..write('concerns: $concerns, ')
          ..write('goals: $goals, ')
          ..write('isColorTreated: $isColorTreated, ')
          ..write('isHeatDamaged: $isHeatDamaged, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $DailyLogsTable dailyLogs = $DailyLogsTable(this);
  late final $HairProfilesTable hairProfiles = $HairProfilesTable(this);
  late final ProductsDao productsDao = ProductsDao(this as AppDatabase);
  late final DailyLogsDao dailyLogsDao = DailyLogsDao(this as AppDatabase);
  late final HairProfilesDao hairProfilesDao = HairProfilesDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    dailyLogs,
    hairProfiles,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> brand,
      required String category,
      Value<String?> ingredients,
      Value<double?> rating,
      Value<bool> isFavorite,
      Value<String?> notes,
      Value<String?> imageUrl,
      Value<DateTime?> purchaseDate,
      Value<DateTime?> expiryDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> brand,
      Value<String> category,
      Value<String?> ingredients,
      Value<double?> rating,
      Value<bool> isFavorite,
      Value<String?> notes,
      Value<String?> imageUrl,
      Value<DateTime?> purchaseDate,
      Value<DateTime?> expiryDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> ingredients = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                brand: brand,
                category: category,
                ingredients: ingredients,
                rating: rating,
                isFavorite: isFavorite,
                notes: notes,
                imageUrl: imageUrl,
                purchaseDate: purchaseDate,
                expiryDate: expiryDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> brand = const Value.absent(),
                required String category,
                Value<String?> ingredients = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                brand: brand,
                category: category,
                ingredients: ingredients,
                rating: rating,
                isFavorite: isFavorite,
                notes: notes,
                imageUrl: imageUrl,
                purchaseDate: purchaseDate,
                expiryDate: expiryDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$DailyLogsTableCreateCompanionBuilder =
    DailyLogsCompanion Function({
      Value<int> id,
      required DateTime date,
      required String routineType,
      Value<String?> productsUsed,
      Value<String?> techniques,
      Value<int?> hairConditionRating,
      Value<String?> weather,
      Value<int?> humidityLevel,
      Value<String?> notes,
      Value<String?> photoUrls,
      Value<DateTime> createdAt,
    });
typedef $$DailyLogsTableUpdateCompanionBuilder =
    DailyLogsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> routineType,
      Value<String?> productsUsed,
      Value<String?> techniques,
      Value<int?> hairConditionRating,
      Value<String?> weather,
      Value<int?> humidityLevel,
      Value<String?> notes,
      Value<String?> photoUrls,
      Value<DateTime> createdAt,
    });

class $$DailyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routineType => $composableBuilder(
    column: $table.routineType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productsUsed => $composableBuilder(
    column: $table.productsUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get techniques => $composableBuilder(
    column: $table.techniques,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hairConditionRating => $composableBuilder(
    column: $table.hairConditionRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get humidityLevel => $composableBuilder(
    column: $table.humidityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrls => $composableBuilder(
    column: $table.photoUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routineType => $composableBuilder(
    column: $table.routineType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productsUsed => $composableBuilder(
    column: $table.productsUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get techniques => $composableBuilder(
    column: $table.techniques,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hairConditionRating => $composableBuilder(
    column: $table.hairConditionRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get humidityLevel => $composableBuilder(
    column: $table.humidityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrls => $composableBuilder(
    column: $table.photoUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get routineType => $composableBuilder(
    column: $table.routineType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productsUsed => $composableBuilder(
    column: $table.productsUsed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get techniques => $composableBuilder(
    column: $table.techniques,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hairConditionRating => $composableBuilder(
    column: $table.hairConditionRating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weather =>
      $composableBuilder(column: $table.weather, builder: (column) => column);

  GeneratedColumn<int> get humidityLevel => $composableBuilder(
    column: $table.humidityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoUrls =>
      $composableBuilder(column: $table.photoUrls, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DailyLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyLogsTable,
          DailyLog,
          $$DailyLogsTableFilterComposer,
          $$DailyLogsTableOrderingComposer,
          $$DailyLogsTableAnnotationComposer,
          $$DailyLogsTableCreateCompanionBuilder,
          $$DailyLogsTableUpdateCompanionBuilder,
          (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
          DailyLog,
          PrefetchHooks Function()
        > {
  $$DailyLogsTableTableManager(_$AppDatabase db, $DailyLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> routineType = const Value.absent(),
                Value<String?> productsUsed = const Value.absent(),
                Value<String?> techniques = const Value.absent(),
                Value<int?> hairConditionRating = const Value.absent(),
                Value<String?> weather = const Value.absent(),
                Value<int?> humidityLevel = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoUrls = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyLogsCompanion(
                id: id,
                date: date,
                routineType: routineType,
                productsUsed: productsUsed,
                techniques: techniques,
                hairConditionRating: hairConditionRating,
                weather: weather,
                humidityLevel: humidityLevel,
                notes: notes,
                photoUrls: photoUrls,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String routineType,
                Value<String?> productsUsed = const Value.absent(),
                Value<String?> techniques = const Value.absent(),
                Value<int?> hairConditionRating = const Value.absent(),
                Value<String?> weather = const Value.absent(),
                Value<int?> humidityLevel = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoUrls = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyLogsCompanion.insert(
                id: id,
                date: date,
                routineType: routineType,
                productsUsed: productsUsed,
                techniques: techniques,
                hairConditionRating: hairConditionRating,
                weather: weather,
                humidityLevel: humidityLevel,
                notes: notes,
                photoUrls: photoUrls,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyLogsTable,
      DailyLog,
      $$DailyLogsTableFilterComposer,
      $$DailyLogsTableOrderingComposer,
      $$DailyLogsTableAnnotationComposer,
      $$DailyLogsTableCreateCompanionBuilder,
      $$DailyLogsTableUpdateCompanionBuilder,
      (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
      DailyLog,
      PrefetchHooks Function()
    >;
typedef $$HairProfilesTableCreateCompanionBuilder =
    HairProfilesCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> primaryType,
      Value<List<String>> specificPatterns,
      Value<bool> isMultiTextured,
      Value<String?> porosity,
      Value<String?> density,
      Value<String?> thickness,
      Value<String?> scalpType,
      Value<double?> hairLength,
      Value<String?> concerns,
      Value<String?> goals,
      Value<bool> isColorTreated,
      Value<bool> isHeatDamaged,
      Value<DateTime> lastUpdated,
    });
typedef $$HairProfilesTableUpdateCompanionBuilder =
    HairProfilesCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> primaryType,
      Value<List<String>> specificPatterns,
      Value<bool> isMultiTextured,
      Value<String?> porosity,
      Value<String?> density,
      Value<String?> thickness,
      Value<String?> scalpType,
      Value<double?> hairLength,
      Value<String?> concerns,
      Value<String?> goals,
      Value<bool> isColorTreated,
      Value<bool> isHeatDamaged,
      Value<DateTime> lastUpdated,
    });

class $$HairProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $HairProfilesTable> {
  $$HairProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryType => $composableBuilder(
    column: $table.primaryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get specificPatterns => $composableBuilder(
    column: $table.specificPatterns,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isMultiTextured => $composableBuilder(
    column: $table.isMultiTextured,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get porosity => $composableBuilder(
    column: $table.porosity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get density => $composableBuilder(
    column: $table.density,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thickness => $composableBuilder(
    column: $table.thickness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scalpType => $composableBuilder(
    column: $table.scalpType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hairLength => $composableBuilder(
    column: $table.hairLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get concerns => $composableBuilder(
    column: $table.concerns,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isColorTreated => $composableBuilder(
    column: $table.isColorTreated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHeatDamaged => $composableBuilder(
    column: $table.isHeatDamaged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HairProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $HairProfilesTable> {
  $$HairProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryType => $composableBuilder(
    column: $table.primaryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specificPatterns => $composableBuilder(
    column: $table.specificPatterns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMultiTextured => $composableBuilder(
    column: $table.isMultiTextured,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get porosity => $composableBuilder(
    column: $table.porosity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get density => $composableBuilder(
    column: $table.density,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thickness => $composableBuilder(
    column: $table.thickness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scalpType => $composableBuilder(
    column: $table.scalpType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hairLength => $composableBuilder(
    column: $table.hairLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get concerns => $composableBuilder(
    column: $table.concerns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isColorTreated => $composableBuilder(
    column: $table.isColorTreated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHeatDamaged => $composableBuilder(
    column: $table.isHeatDamaged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HairProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HairProfilesTable> {
  $$HairProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get primaryType => $composableBuilder(
    column: $table.primaryType,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get specificPatterns =>
      $composableBuilder(
        column: $table.specificPatterns,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isMultiTextured => $composableBuilder(
    column: $table.isMultiTextured,
    builder: (column) => column,
  );

  GeneratedColumn<String> get porosity =>
      $composableBuilder(column: $table.porosity, builder: (column) => column);

  GeneratedColumn<String> get density =>
      $composableBuilder(column: $table.density, builder: (column) => column);

  GeneratedColumn<String> get thickness =>
      $composableBuilder(column: $table.thickness, builder: (column) => column);

  GeneratedColumn<String> get scalpType =>
      $composableBuilder(column: $table.scalpType, builder: (column) => column);

  GeneratedColumn<double> get hairLength => $composableBuilder(
    column: $table.hairLength,
    builder: (column) => column,
  );

  GeneratedColumn<String> get concerns =>
      $composableBuilder(column: $table.concerns, builder: (column) => column);

  GeneratedColumn<String> get goals =>
      $composableBuilder(column: $table.goals, builder: (column) => column);

  GeneratedColumn<bool> get isColorTreated => $composableBuilder(
    column: $table.isColorTreated,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isHeatDamaged => $composableBuilder(
    column: $table.isHeatDamaged,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$HairProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HairProfilesTable,
          HairProfile,
          $$HairProfilesTableFilterComposer,
          $$HairProfilesTableOrderingComposer,
          $$HairProfilesTableAnnotationComposer,
          $$HairProfilesTableCreateCompanionBuilder,
          $$HairProfilesTableUpdateCompanionBuilder,
          (
            HairProfile,
            BaseReferences<_$AppDatabase, $HairProfilesTable, HairProfile>,
          ),
          HairProfile,
          PrefetchHooks Function()
        > {
  $$HairProfilesTableTableManager(_$AppDatabase db, $HairProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HairProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HairProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HairProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> primaryType = const Value.absent(),
                Value<List<String>> specificPatterns = const Value.absent(),
                Value<bool> isMultiTextured = const Value.absent(),
                Value<String?> porosity = const Value.absent(),
                Value<String?> density = const Value.absent(),
                Value<String?> thickness = const Value.absent(),
                Value<String?> scalpType = const Value.absent(),
                Value<double?> hairLength = const Value.absent(),
                Value<String?> concerns = const Value.absent(),
                Value<String?> goals = const Value.absent(),
                Value<bool> isColorTreated = const Value.absent(),
                Value<bool> isHeatDamaged = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
              }) => HairProfilesCompanion(
                id: id,
                name: name,
                primaryType: primaryType,
                specificPatterns: specificPatterns,
                isMultiTextured: isMultiTextured,
                porosity: porosity,
                density: density,
                thickness: thickness,
                scalpType: scalpType,
                hairLength: hairLength,
                concerns: concerns,
                goals: goals,
                isColorTreated: isColorTreated,
                isHeatDamaged: isHeatDamaged,
                lastUpdated: lastUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> primaryType = const Value.absent(),
                Value<List<String>> specificPatterns = const Value.absent(),
                Value<bool> isMultiTextured = const Value.absent(),
                Value<String?> porosity = const Value.absent(),
                Value<String?> density = const Value.absent(),
                Value<String?> thickness = const Value.absent(),
                Value<String?> scalpType = const Value.absent(),
                Value<double?> hairLength = const Value.absent(),
                Value<String?> concerns = const Value.absent(),
                Value<String?> goals = const Value.absent(),
                Value<bool> isColorTreated = const Value.absent(),
                Value<bool> isHeatDamaged = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
              }) => HairProfilesCompanion.insert(
                id: id,
                name: name,
                primaryType: primaryType,
                specificPatterns: specificPatterns,
                isMultiTextured: isMultiTextured,
                porosity: porosity,
                density: density,
                thickness: thickness,
                scalpType: scalpType,
                hairLength: hairLength,
                concerns: concerns,
                goals: goals,
                isColorTreated: isColorTreated,
                isHeatDamaged: isHeatDamaged,
                lastUpdated: lastUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HairProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HairProfilesTable,
      HairProfile,
      $$HairProfilesTableFilterComposer,
      $$HairProfilesTableOrderingComposer,
      $$HairProfilesTableAnnotationComposer,
      $$HairProfilesTableCreateCompanionBuilder,
      $$HairProfilesTableUpdateCompanionBuilder,
      (
        HairProfile,
        BaseReferences<_$AppDatabase, $HairProfilesTable, HairProfile>,
      ),
      HairProfile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db, _db.dailyLogs);
  $$HairProfilesTableTableManager get hairProfiles =>
      $$HairProfilesTableTableManager(_db, _db.hairProfiles);
}
