import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart';
import '../../data/models/product_model.dart';
import '../bloc/product_cubit.dart';
import '../bloc/product_state.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  static String route = '/product-list';

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<String> _categories = const [
    "All", "Electronics", "Accessories", "Fashion", "Grocery", "Furniture", "Stationery", "Home Appliances"
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductCubit>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        title: Text("product_list".tr(), style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) return const Center(child: CircularProgressIndicator());
                if (state is ProductError) return Center(child: Text(state.message));

                if (state is ProductLoaded) {
                  if (state.products.isEmpty) return const Center(child: Text("No Data Found"));

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: state.hasReachedMax ? state.products.length : state.products.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.products.length) {
                        return const Center(child: Padding(padding: EdgeInsets.all(15), child: CircularProgressIndicator()));
                      }
                      return _buildProductCard(state.products[index]);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cubit = context.read<ProductCubit>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: AppColors.cardWhite,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: (val) => cubit.applySearchAndFilter(query: val),
              decoration: InputDecoration(
                hintText: "search_hint".tr(),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true, fillColor: AppColors.scaffoldBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
          const Gap(10),
          Container(
            width: 110,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: AppColors.scaffoldBg, borderRadius: BorderRadius.circular(10)),
            child: DropdownButtonHideUnderline(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  return DropdownButton<String>(
                    value: cubit.currentCategory,
                    isExpanded: true,
                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 11)))).toList(),
                    onChanged: (val) => cubit.applySearchAndFilter(category: val),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      color: AppColors.cardWhite,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(product.category),
        trailing: Text("TK ${product.price.toStringAsFixed(0)}", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ),
    );
  }
}