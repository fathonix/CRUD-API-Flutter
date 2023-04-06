import 'dart:developer';

import 'package:crud_api_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  void _showAlertDialog(Product product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Apakah kamu yakin hapus ${product.name}?'),
        actions: [
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await ProductService.deleteProduct(product.id!);
              },
              child: Text('Ya')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tidak')),
        ],
      ),
    );
  }

  void _showBottomSheet({Product? product, required bool isUpdate}) {
    if (isUpdate) {
      nameController.text = product!.name!;
      priceController.text = product.price!.toString();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create Product',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama Produk nggak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    log('Nama Product $value');
                  },
                  decoration: InputDecoration(
                    hintText: 'Redmi 3',
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Harga Produk nggak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    log('Harga Product $value');
                  },
                  decoration: InputDecoration(
                    hintText: '40000',
                    labelText: 'Product Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final name = nameController.text;
                        final price = priceController.text;
                        Navigator.of(context).pop();
                        if (isUpdate) {
                          await ProductService.updateProduct(
                            id: product!.id!,
                            name: name,
                            price: price,
                          );
                        } else {
                          await ProductService.createProduct(
                            name: name,
                            price: price,
                          );
                        }

                        nameController.clear();
                        priceController.clear();
                      } else {
                        log('Nggak valid');
                      }
                    },
                    child: Text(isUpdate ? 'Update' : 'Create')),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showBottomSheet(isUpdate: false);
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name!),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(NumberFormat.currency(
                                locale: 'id-ID',
                                name: 'Rp ',
                                decimalDigits: 0,
                              ).format(product.price)),
                              Row(
                                children: [
                                  // !TOMBOL EDIT
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber),
                                      onPressed: () {
                                        _showBottomSheet(
                                            isUpdate: true, product: product);
                                      },
                                      icon: Icon(Icons.edit),
                                      label: Text('Edit')),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  // !TOMBOL DELETE
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () {
                                        _showAlertDialog(product);
                                      },
                                      icon: Icon(Icons.delete),
                                      label: Text('Delete')),
                                ],
                              ),
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
