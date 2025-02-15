import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_state/cart_provider.dart';
import 'package:shopping_cart_state/cart_item.dart';
import 'package:shopping_cart_state/main.dart';

class ProductScreen extends StatelessWidget {
  final List<CartItem> products = List.generate(
    20,
    (i) => CartItem(
      id: Random().nextInt(1000).toString(),
      title: WordPair.random().asPascalCase,
      price: Random().nextInt(100).toDouble(),
      quantity: 1,
    ),
  );

  ProductScreen({super.key, required List products});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
        backgroundColor: const Color.fromARGB(255, 47, 48, 49),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => CartScreen()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, i) {
          final product = products[i];
          return ListTile(
            title: Text(product.title),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            trailing: FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Quantity: ${product.quantity}'),
                  IconButton(
                    onPressed: () {
                      cart.addItem(product.id, product.title, product.price,
                          product.quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added to Cart!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
