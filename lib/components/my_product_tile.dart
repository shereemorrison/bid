import 'package:bid/modals/products.dart';
import 'package:bid/modals/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProductTile extends StatelessWidget {

  final Product product;
  final bool isSmall;

  const MyProductTile({
    super.key,
    required this.product,
    this.isSmall = false
  });

  //add to cart button pressed
  void addToCart(BuildContext context) {
    // Show the dialog with a success message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text("Item added to cart!"),
      ),
    );

    // Add item to cart
    context.read<Shop>().addToCart(product);

    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);  // Close the dialog after 1 second
    });
  }

  // Add to wishlist button pressed
  void addToWishlist(BuildContext context) {
    // Show the dialog with a success message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text("Item added to wishlist!"),
      ),
    );

    // Add item to wishlist
    context.read<Shop>().addToWishlist(product);

    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);  // Close the dialog after 1 second
    });
  }


  @override
  Widget build(BuildContext context) {
    double imageSize = isSmall ? 80 : 150;
    double fontSize = isSmall ? 12 : 15;
    double padding = isSmall ? 5 : 10;

    return Container(
      padding: const EdgeInsets.all(10),
      width: 200,
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,

        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.all((10)),
                  child: Image.asset(product.imagePath),
                ),
              ),
              const SizedBox(height: 10),


              //product name
              Text(
                product.name,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),

              //product description
              Text(
                product.description,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: isSmall ? 8 : 10),
              ),
            ],
          ),

          const SizedBox(height:10),

          //product price and add to cart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$' + product.price.toStringAsFixed(2),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary)),

              Spacer(),

              // Add to wishlist button
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => addToWishlist(context),
                  icon: Icon(Icons.favorite_border, size: 20),
                  padding: EdgeInsets.zero,
                ),
              ),

              SizedBox(width: 5),

              //add to cart button
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: IconButton(
                  onPressed: () => addToCart(context),
                  icon: Icon(Icons.add, size: 20),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
