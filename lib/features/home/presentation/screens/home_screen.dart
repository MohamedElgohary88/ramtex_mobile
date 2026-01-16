import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/home_data.dart';
import '../../../products/domain/params/product_filter_params.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/brand_item_widget.dart';
import '../widgets/category_item_widget.dart';
import '../widgets/home_carousel_widget.dart';
import '../widgets/product_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data on init
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: _buildAppBar(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<HomeCubit>().loadHomeData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is HomeLoaded) {
            return _buildHomeContent(state.homeData);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          readOnly: true,
          onTap: () => context.pushNamed(AppRouter.products),
          decoration: InputDecoration(
            hintText: 'Search products, brands...',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => context.pushNamed(AppRouter.favorites),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {}, // Todo: Notifications
        ),
      ],
    );
  }

  Widget _buildHomeContent(HomeData data) {
    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().loadHomeData(),
      child: CustomScrollView(
        slivers: [
          // 1. Hero Carousel (Pager)
          if (data.featuredProducts.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                child: HomeCarouselWidget(
                  // Show top 5 items or less
                  products: data.featuredProducts.take(5).toList(),
                ),
              ),
            ),

          // 2. Categories
          if (data.categories.isNotEmpty) ...[
            _buildSectionTitle(
              'Browse Categories',
              onSeeAll: () => context.pushNamed(
                AppRouter.products,
                extra: ProductFilterParams(), // All products
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final category = data.categories[index];
                    return CategoryItemWidget(
                      category: category,
                      onTap: () => context.pushNamed(
                        AppRouter.products,
                        extra: ProductFilterParams(categoryId: category.id),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          // 3. Brands
          if (data.brands.isNotEmpty) ...[
            _buildSectionTitle('Shop by Brand'),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 60,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.brands.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final brand = data.brands[index];
                    return BrandItemWidget(
                      brand: brand,
                      onTap: () => context.pushNamed(
                        AppRouter.products,
                        extra: ProductFilterParams(brandId: brand.id),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          // 4. New Arrivals (Grid)
          if (data.featuredProducts.isNotEmpty) ...[
            _buildSectionTitle(
              'New Arrivals',
              onSeeAll: () => context.pushNamed(
                AppRouter.products,
                extra: ProductFilterParams(sort: 'created_at'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductCardWidget(product: data.featuredProducts[index]);
                  },
                  childCount: data.featuredProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65, // Adjusted for taller card
                ),
              ),
            ),
          ],

          // 5. Best Sellers (Simulated for now with reversed list)
          if (data.featuredProducts.isNotEmpty) ...[
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            _buildSectionTitle(
              'Best Sellers',
              onSeeAll: () => context.pushNamed(
                AppRouter.products,
                extra: ProductFilterParams(
                  sort: 'price_desc',
                ), // Logic for "best"
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  // Show in reverse order to simulate "different" content
                  final reversedIndex =
                      data.featuredProducts.length - 1 - index;
                  return ProductCardWidget(
                    product: data.featuredProducts[reversedIndex],
                  );
                }, childCount: data.featuredProducts.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 48),
            ), // Bottom padding
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAll}) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (onSeeAll != null)
              GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  'See All',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
