import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

final productProvider = FutureProvider<List<Product>>((ref) async {
  final response = await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products/?categorySlug=clothes'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  }
  return [];
});

final productDetailProvider = FutureProvider.family<Product, int>((ref, id) async {
  final response = await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products/$id'));
  if (response.statusCode == 200) {
    return Product.fromJson(jsonDecode(response.body));
  }
  throw Exception('Failed to load product details');
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>((ref) => FavoritesNotifier());

class FavoritesNotifier extends StateNotifier<Set<int>> {
  FavoritesNotifier() : super({});

  void toggleFavorite(int productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
  }
}