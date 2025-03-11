import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bid/modals/products.dart';
import 'package:bid/modals/shop.dart';
import 'package:bid/modals/paymentmodal.dart';
import 'package:bid/components/my_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  // Remove item from cart
  void removeItemFromCart(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Remove this from your cart?"),
        actions: [

          // Cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // Yes button
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);  // Close the dialog first
              Future.delayed(Duration(milliseconds: 200), () {
                context.read<Shop>().removeFromCart(product);  // Perform the action after the dialog closes
              });
            },
            child: const Text("Yes"),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Shop>().cart;
    double totalAmount = cart.fold(0.0, (sum, item) => sum + item.price);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: cart.isEmpty
          ? Center(
        child: Text(
          "You have nothing in your cart",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: ListTile(
                      leading: Image.asset('${item.imagePath}'),
                      title: Text(item.name),
                      subtitle: Text(item.price.toStringAsFixed(2)),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        onPressed: () => removeItemFromCart(context, item),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Total amount
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // Pay now button
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: MyButton(
              text: "Pay Now",
              onTap: () {
                if (mounted) {
                  // Use GoRouter to navigate
                  context.go('/paymentmodal', extra: totalAmount);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
