// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CoinCard extends StatelessWidget {
  String name;
  String symbol;
  String image;
  double price;
  double change;
  double changePercentage;
  int rank;

  CoinCard(
      {required this.change,
      required this.changePercentage,
      required this.image,
      required this.name,
      required this.price,
      required this.rank,
      required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.black, border: Border(bottom: BorderSide())),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              height: 60,
              width: 60,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Image.network(image),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(name,
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          color: Colors.white.withOpacity(.30),
                          child: Center(
                            child: Text(
                              rank.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          symbol.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price.toDouble().toString(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  change.toDouble() < 0
                      ? change.toDouble().toStringAsFixed(3)
                      : '+' + change.toDouble().toStringAsFixed(3),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  changePercentage.toDouble() < 0
                      ? changePercentage.toDouble().toString() + '%'
                      : '+' + changePercentage.toDouble().toString() + '%',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
