import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/product_card_widget.dart';
import '../../domain/params/product_filter_params.dart';
import '../cubit/product_list_cubit.dart';
import '../cubit/product_list_state.dart';
import '../widgets/filter_bottom_sheet.dart';

class SearchScreen extends StatefulWidget {
  final ProductFilterParams? initialFilters;

  const SearchScreen({super.key, this.initialFilters});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Initialize filters if provided
    if (widget.initialFilters != null) {
      if (widget.initialFilters!.searchQuery != null) {
        _searchController.text = widget.initialFilters!.searchQuery!;
      }
      // Delay slightly to let the updated Cubit instance be ready if needed,
      // or just call updateFilters directly which loads products.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductListCubit>().updateFilters(widget.initialFilters!);
      });
    } else {
      // Initial Load with default parameters if no initial filters are provided
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductListCubit>().loadProducts();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductListCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final cubit = context.read<ProductListCubit>();
      final state = cubit.state;
      // Get previous params or default
      final previousParams = state is ProductListLoaded
          ? state.params
          : const ProductFilterParams();

      cubit.updateFilters(previousParams.copyWith(searchQuery: query));
    });
  }

  void _openFilterSheet(BuildContext context) {
    final cubit = context.read<ProductListCubit>();
    final state = cubit.state;
    final currentParams = state is ProductListLoaded
        ? state.params
        : const ProductFilterParams(searchQuery: ''); // Fallback

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FilterBottomSheet(
        currentParams: currentParams,
        onApply: (params) {
          cubit.updateFilters(params);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: _buildSearchBar(),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _openFilterSheet(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProductListCubit, ProductListState>(
        builder: (context, state) {
          if (state is ProductListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProductListCubit>().updateFilters(
                          const ProductFilterParams(),
                        ), // Retry basically
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ProductListLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No products found'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductListCubit>().updateFilters(state.params);
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65, // Adjust as needed
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: state.hasReachedMax
                    ? state.products.length
                    : state.products.length + 1, // +1 for loader
                itemBuilder: (context, index) {
                  if (index >= state.products.length) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  final product = state.products[index];
                  return ProductCardWidget(
                    product: product,
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 16, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search products...',
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: AppColors.textSecondary,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 16),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}
