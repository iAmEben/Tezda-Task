import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';

@RoutePage()
class ProductDetailScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailScreen({super.key, @PathParam('id') required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));
    final favorites = ref.watch(favoritesProvider);
    var heightOfStack = MediaQuery.of(context).size.height / 2.8;
    return Scaffold(
      body: SafeArea(
        child: productAsync.when(
          data: (product) => Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          product.image,
                          width: MediaQuery.of(context).size.width,
                          height: heightOfStack,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 16, top: 16),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => context.router.pop(),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: Icon(Icons.arrow_back, color: Colors.white),
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                child: const Icon(Icons.share, color: Colors.white),
                              ),
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(product.id),
                                child: Icon(
                                  favorites.contains(product.id) ? Icons.favorite : Icons.favorite_border,
                                  color: favorites.contains(product.id) ? Colors.red : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Description',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Specifications',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Category: ${product.category}\nPrice: \$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'User Reviews',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...createUserReviews(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  List<Widget> createUserReviews() {
    List<Widget> userReviews = [];
    List<String> userNames = ['Collin Fields', 'Sherita Burns', 'Bill Sacks'];
    List<String> descriptions = [
      'Great product, very comfortable!',
      'Good quality, but delivery was slow.',
      'Highly recommend, worth the price!',
    ];

    for (var i = 0; i < userNames.length; i++) {
      userReviews.add(ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        title: Text(
          userNames[i],
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          descriptions[i],
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      ));
    }
    return userReviews;
  }
}