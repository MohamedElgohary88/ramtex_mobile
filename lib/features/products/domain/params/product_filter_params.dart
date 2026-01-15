class ProductFilterParams {
  final String? searchQuery;
  final int? categoryId;
  final int? brandId;
  final double? priceMin;
  final double? priceMax;
  final String? sort; // 'price_asc', 'price_desc', 'newest'
  final int page;
  final int perPage;

  const ProductFilterParams({
    this.searchQuery,
    this.categoryId,
    this.brandId,
    this.priceMin,
    this.priceMax,
    this.sort,
    this.page = 1,
    this.perPage = 10,
  });

  ProductFilterParams copyWith({
    String? searchQuery,
    int? categoryId,
    int? brandId,
    double? priceMin,
    double? priceMax,
    String? sort,
    int? page,
    int? perPage,
  }) {
    return ProductFilterParams(
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      sort: sort ?? this.sort,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      map['search'] = searchQuery;
    }
    if (categoryId != null) map['category_id'] = categoryId;
    if (brandId != null) map['brand_id'] = brandId;
    if (priceMin != null) map['price_min'] = priceMin;
    if (priceMax != null) map['price_max'] = priceMax;
    if (sort != null) map['sort'] = sort;
    
    return map;
  }
}
