// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:dapp/widgets/button_widget.dart';
import 'package:dapp/widgets/design/coin_card.dart';
import 'package:flutter/material.dart';
import 'widgets/total_balance.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/coins.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Coin> coinList = [];
  bool isLoading = true;
  String errorMessage = "";

  Future<void> fetchCoin() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=1h'));

      if (response.statusCode == 200) {
        List<dynamic> values = json.decode(response.body);
        coinList =
            values.map((coin) => Coin.fromJson(coin)).toList().sublist(0, 20);

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to load data, try again";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "An error occurred: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCoin();
    Timer.periodic(const Duration(seconds: 10), (timer) => fetchCoin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Top Crypto Stocks"),
        backgroundColor: const Color.fromARGB(255, 5, 9, 231),
        leading: BackButton(),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(
                    child:
                        Text(errorMessage, style: TextStyle(color: Colors.red)))
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: ListView.builder(
                              itemCount: coinList.length,
                              itemBuilder: (context, index) {
                                return CoinCard(
                                  change: coinList[index].change.toDouble(),
                                  changePercentage: coinList[index]
                                      .changePercentage
                                      .toDouble(),
                                  image: coinList[index].image,
                                  name: coinList[index].name,
                                  price: coinList[index].price.toDouble(),
                                  rank: coinList[index].rank.toInt(),
                                  symbol: coinList[index].symbol,
                                );
                              }),
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
