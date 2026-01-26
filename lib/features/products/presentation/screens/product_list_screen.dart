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

  final List<String> categories = const [
    "All", "Electronics", "Accessories", "Fashion", "Grocery", "Furniture", "Stationery", "Home Appliances"
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductCubit>().loadProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<ProductCubit>().fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        title: Text(
          "product_list".tr(), 
          style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)
        ),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
         
          _buildSearchFilterHeader(context),

         
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (state is ProductLoaded) {
                  if (state.products.isEmpty) {
                    return Center(child: Text("no_products".tr(), style: const TextStyle(color: AppColors.black)));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: state.hasReachedMax 
                        ? state.products.length 
                        : state.products.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.products.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      return _buildProductCard(state.products[index]);
                    },
                  );
                }

                if (state is ProductError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilterHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: AppColors.cardWhite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          Expanded(
            child: TextFormField(
              style: const TextStyle(color: AppColors.black, fontSize: 14),
              onChanged: (val) => context.read<ProductCubit>().applySearchAndFilter(query: val),
              decoration: InputDecoration(
                hintText: "search_hint".tr(),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
                filled: true,
                fillColor: AppColors.scaffoldBg,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
          
          const Gap(10), 
          
          Container(
            width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: context.watch<ProductCubit>().currentCategory,
                isExpanded: true,
                icon: const Icon(Icons.filter_list, color: AppColors.primary, size: 18),
                style: const TextStyle(color: AppColors.black, fontSize: 12, fontWeight: FontWeight.w600),
                items: categories.map((String c) {
                  return DropdownMenuItem<String>(
                    value: c, 
                    child: Text(c, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    context.read<ProductCubit>().applySearchAndFilter(category: val);
                  }
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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.greyBorder, width: 0.5),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 24),
        ),
        title: Text(
          product.name, 
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.black, fontSize: 15)
        ),
        subtitle: Text(
          product.category, 
          style: const TextStyle(color: AppColors.greyText, fontSize: 12)
        ),
        trailing: Text(
          "TK ${product.price.toStringAsFixed(0)}", 
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)
        ),
      ),
    );
  }
}