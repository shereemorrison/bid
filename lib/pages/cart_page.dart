import 'package:bid/components/my_button.dart';
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
            child: Column(

              //CUSTOMER CART
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Padding(
                        padding: const EdgeInsets.only(left:20,top:20,right:20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).colorScheme.secondary,

                          ),
                          child: ListTile(
                            leading: Image.asset(
                                '${item.imagePath}', ),
                            title: Text(item.name),
                            subtitle: Text(item.price.toStringAsFixed(2)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey,),
                              onPressed: () => removeItemFromCart(context, item),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                //PAY NOW BUTTON
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: MyButton(onTap: (){}, text: "Pay Now"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}