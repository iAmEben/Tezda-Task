import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';
import '../routes/route.dart';
import '../values/styles.dart';
import '../widgets/product_card.dart';
import '../widgets/search_input_field.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => context.router.push(const ProfileRoute()),
              ),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            children: [
              CustomSearchInputField(
                'assets/images/search_icon.png',
                textFormFieldStyle: TextStyle(color: Colors.black54),
                hintText: 'Search products...',
                hintTextStyle: TextStyle(color: Colors.black54),
                suffixIconImagePath: 'assets/images/settings_icon.png',
                borderWidth: 0.0,
                borderStyle: BorderStyle.solid,
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: productsAsync.when(
                  data: (products) => products.isEmpty
                    ? Center(child: Text('There are no products right now', style: Styles.normalTextStyle))
                    :ListView.separated(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          width: MediaQuery.of(context).size.width * 0.9,
                        );
                      }, separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16,),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
