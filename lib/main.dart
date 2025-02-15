import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_state/cart_item.dart';
import 'package:shopping_cart_state/cart_provider.dart';
import 'package:shopping_cart_state/product_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductScreen(
        products: [],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) =>
                  CartItemWidget(cart.items.values.toList()[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: Provider.of<CartProvider>(context, listen: false).clear,
        tooltip: 'Clear Cart',
        child: const Icon(Icons.delete),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  const CartItemWidget(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text('Price: \$${item.price} x ${item.quantity}'),
      trailing: FittedBox(
        child: Row(
          children: [
            Text(
              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            IconButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .removeItem(item.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed from Cart!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(Icons.delete, color: Colors.red),
            ),
            IconButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .decrementQuantity(item.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Decremented -1 from Cart!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(Icons.remove, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
