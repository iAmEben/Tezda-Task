import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

final productProvider = FutureProvider<List<Product>>((ref) async {
  try {
    final url = Uri.parse('https://api.escuelajs.co/api/v1/products');
    print('Products GET Request:');
    print('URL: $url');
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    print('Products Response Status: ${response.statusCode}');
    print('Products Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    }
    throw Exception('Failed to load products: ${response.statusCode}');
  } catch (e) {
    print('Products Error: $e');
    throw Exception('Failed to load products: $e');
  }
});

final productDetailProvider = FutureProvider.family<Product, int>((ref, id) async {
  final response = await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products/$id'));
  if (kDebugMode) {
    print('Product Detail Request:');
  }
  if (kDebugMode) {
    print('URL: $response');
  }
  if (response.statusCode == 200) {
    if (kDebugMode) {
      print('Product: ${response.body}');
    }
    return Product.fromJson(jsonDecode(response.body));
  }
  if (kDebugMode) {
    print('Product Failed to load: ${response.statusCode}, ${response.body}');
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