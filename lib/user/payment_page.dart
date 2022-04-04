import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key, required this.type}) : super(key: key);
  final String type;
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _expireController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String type = widget.type;
    AlertDialog alert = AlertDialog(
      title: const Text("Payment Submitted Sucessfully"),
      content: const Text("Your Request is in Pending until Confirmation"),
      actions: [
        TextButton(
            onPressed: () {
              int count = 0;
              if (type == "Rent Banner") {
                Navigator.of(context).popUntil((route) => count++ >= 3);
              } else if (type == "New Store") {
                Navigator.of(context).popUntil((route) => count++ >= 7);
              }
            },
            child: const Text("Return"))
      ],
      elevation: 10,
    );
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("$type Payment "),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1, // soften the shadow
                spreadRadius: 0.0001, //extend the shadow
                offset: Offset(
                  2.0, // Move to right 10  horizontally
                  2.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          margin: EdgeInsets.only(
              top: screenHeight / 8,
              left: screenWidth / 9,
              right: screenWidth / 9),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 15,
                ),
                child: Text(
                  "Enter Payment Details",
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 10, right: 15, left: 15, bottom: 5),
                child: TextFormField(
                    maxLength: 30,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'e.g. John Doe',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 15)),
              ),
              Container(
                margin: const EdgeInsets.only(right: 15, left: 15, bottom: 5),
                child: TextFormField(
                  maxLength: 16,
                  keyboardType: TextInputType.number,
                  controller: _cardController,
                  decoration: const InputDecoration(
                    labelText: 'Card Number ',
                    hintText: 'e.g. xxxx xxxx xxxx xxxx',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Center(
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 70,
                      margin: const EdgeInsets.only(top: 5, left: 15),
                      child: TextFormField(
                          maxLength: 5,
                          onChanged: (value) {
                            if (value.length == 2) {
                              _expireController.text += "/";
                            }
                          },
                          keyboardType: TextInputType.number,
                          controller: _expireController,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            labelText: 'Expiry Date',
                            hintText: 'mm/yy',
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 15)),
                    ),
                    Container(
                      width: 65,
                      height: 70,
                      margin: const EdgeInsets.only(
                        top: 5,
                        left: 15,
                      ),
                      child: TextFormField(
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                          controller: _cvvController,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            labelText: 'CVV',
                            hintText: 'xxx',
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
              Center(
                  child: InkWell(
                child: Container(
                  height: 55,
                  width: 200,
                  margin: const EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(
                    color: kMainColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.blueGrey,
                        blurRadius: 1, // soften the shadow
                        spreadRadius: 0.0001, //extend the shadow
                        offset: Offset(
                          1.0, // Move to right 10  horizontally
                          1.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: const Center(
                      child: Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  )),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      });
                },
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
