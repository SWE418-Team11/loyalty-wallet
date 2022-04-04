import 'package:flutter/material.dart';
import 'package:loyalty_wallet/customer/customer_store_screen.dart';
import 'package:loyalty_wallet/models/store.dart';

class Items extends StatefulWidget {
  final Store store;
  const Items({Key? key, required this.store}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Store store = widget.store;
    String storeBanner = store.storeBanner;
    String storeIcon = store.storeIcon;
    String storeName = store.name;
    return InkWell(
      onTap: () {
        if (store.plan != 'canceled') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerStoreScreen(
                store: store,
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black12,
              offset: Offset(0.5, 1),
            )
          ],
          color: store.plan != 'canceled' ? Colors.white : Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          fit: StackFit.loose,
          children: [
            SizedBox(
              width: size.width,
              height: size.height / 6.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  storeBanner,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: (size.width / 5.5),
              //change location of avatar using top and left

              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(storeIcon),
                backgroundColor: Colors.transparent,
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 2.5) - 30,
              left: 10,
              right: 10,
              child: Text(
                storeName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
