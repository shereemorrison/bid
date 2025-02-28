import 'package:bid/modals/products.dart';
import 'package:bid/modals/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  //remove item from cart
  void removeItemFromCart(BuildContext context, Product product) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              content: const Text("Remove this from your cart?"),
              actions: [
                //cancel button
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                //yes button
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<Shop>().removeFromCart(product);
                  },
                  child: Text("Yes"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final cart = context
        .watch<Shop>()
        .cart;

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .surface,
      body: cart.isEmpty
          ? Center(
        child: Text(
          "You have nothing in your cart",
          style: TextStyle(
              fontSize: 15),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  leading: Image.asset(
                      '${item.imagePath}', ),
                  title: Text(item.name),
                  subtitle: Text(item.price.toStringAsFixed(2)),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => removeItemFromCart(context, item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}