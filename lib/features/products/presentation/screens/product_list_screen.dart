import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart';
import '../../data/models/product_model.dart';
import '../bloc/product_cubit.dart';
import '../bloc/product_state.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

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

                if (state is ProductLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) => _buildProductCard(state.products[index]),
                  );
                }
                return const Center(child: Text("No Data"));
              },
            ),
          ),
         
          _buildPaginationBar(context),
          const Gap(10),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: AppColors.cardWhite,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              style: const TextStyle(color: AppColors.black),
              onChanged: (val) => context.read<ProductCubit>().applySearchAndFilter(query: val),
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
            width: 120,
            decoration: BoxDecoration(color: AppColors.scaffoldBg, borderRadius: BorderRadius.circular(10)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: context.watch<ProductCubit>().currentCategory,
                isExpanded: true,
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12, color: AppColors.black)))).toList(),
                onChanged: (val) => context.read<ProductCubit>().applySearchAndFilter(category: val),
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
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.black)),
        subtitle: Text(product.category, style: const TextStyle(color: AppColors.greyText)),
        trailing: Text("TK ${product.price.toStringAsFixed(0)}", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPaginationBar(BuildContext context) {
    final cubit = context.watch<ProductCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _pageBtn("<", cubit.currentPage > 1, () => cubit.goToPage(cubit.currentPage - 1)),
        const Gap(10),
        Text("Page ${cubit.currentPage} of ${cubit.totalPages}", style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
        const Gap(10),
        _pageBtn(">", cubit.currentPage < cubit.totalPages, () => cubit.goToPage(cubit.currentPage + 1)),
      ],
    );
  }

  Widget _pageBtn(String label, bool enabled, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size(40, 40)),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}