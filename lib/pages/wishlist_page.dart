import 'package:auto_route/annotations.dart';
import 'package:bid/modals/products.dart';
import 'package:bid/modals/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();

}

class _WishlistPageState extends State<WishlistPage> {
  List<Product> wishlist = [];


  //remove item from wishlist
  void removeItemFromWishlist(BuildContext context, Product product) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              content: const Text("Remove this from your wishlist?"),
              actions: [
                //cancel button
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                //yes button
                MaterialButton(
                  onPressed: () {

                    context.read<Shop>().removeFromWishlist(product);
                  },
                  child: Text("Yes"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<Shop>().wishlist;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: wishlist.isEmpty
          ? Center(
        child: Text(
          "You have nothing in your wishlist",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
              fontSize: 20
          ),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: Column(

              //CUSTOMER wishlist
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: wishlist.length,
                    itemBuilder: (context, index) {
                      final item = wishlist[index];
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
                              onPressed: () => removeItemFromWishlist(context, item),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // TOTAL AMOUNT


                //PAY NOW BUTTON

              ],
            ),
          ),
        ],
      ),
    );
  }
}
