import 'package:crud_api_app/models/product.dart';
import 'package:flutter/material.dart';

import '../services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('List Products'),
        ),
        body: FutureBuilder<List<Product>?>(
          future: ProductService.getProducts(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final List<Product> datas = snapshot.data!;

                return ListView.separated(
                    itemBuilder: (_, index) {
                      final product = datas[index];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(product.name!),
                              Text(product.price.toString()),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: datas.length);
              }
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
