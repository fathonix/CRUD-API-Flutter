import 'dart:convert';
import 'dart:developer';

import 'package:crud_api_app/models/product.dart';
import 'package:http/http.dart' as http;
import '../constants/api_config.dart';

class ProductService {
  ProductService._();

  static Future<List<Product>?> getProducts() async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.productEndpoint}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {
          final List listDataJson = responseJson['data'];
          List<Product> products = [];
          for (final json in listDataJson) {
            products.add(Product.fromJson(json));
          }
          return products;
        }
      }
    } catch (e) {
      log('Error get Products $e');
      return null;
    }
  }
}
