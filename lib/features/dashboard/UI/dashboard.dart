import 'package:dapp/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:dapp/features/deposit/deposit.dart';
import 'package:dapp/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'transaction.dart'; // Import for TransactionPage
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SvgPicture import
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboard extends StatefulWidget {
  final String privateKey;

  const Dashboard({Key? key, required this.privateKey});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final DashboardBloc dashboardBloc;
  @override
  void initState() {
    dashboardBloc = DashboardBloc(privateKey: widget.privateKey);
    dashboardBloc.add(DashboardInitialFetchEvent());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: dashboardBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case DashboardLoadingState:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case DashboardErrorState:
              return const Center(
                child: Text("Error"),
              );
            case DashboardSuccessState:
              final successState = state as DashboardSuccessState;
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(30))),
                        padding: const EdgeInsets.all(20.0),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Kry',
                              style: TextStyle(
                                  color: Color.fromARGB(221, 227, 6, 6),
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Transfer',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'NFTs',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 200,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  promoCard('assets/one.jpg', '10 ETH'),
                                  promoCard('assets/two.jpg', '12 ETH'),
                                  promoCard('assets/three.jpg', '13 ETH'),
                                  promoCard('assets/four.jpg', '15 ETH'),
                                  promoCard('assets/five.png', '14 ETH'),
                                  promoCard('assets/six.jpg', '17 ETH'),
                                  promoCard('assets/seven.png', '14 ETH'),
                                  promoCard('assets/eight.png', '10 ETH'),
                                  promoCard('assets/nine.jpg', '21 ETH'),
                                  promoCard('assets/ten.jpg', '19 ETH'),
                                  promoCard('assets/eleven.jpg', '15 ETH'),
                                  promoCard('assets/twelve.jpg', '18 ETH'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DepositPage(
                                            dashboardBloc: dashboardBloc,
                                          )),
                                );
                                dashboardBloc.add(DashboardInitialFetchEvent());
                              },
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/transfer.jpg')),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomRight,
                                        stops: const [
                                          0.3,
                                          0.9
                                        ],
                                        colors: [
                                          const Color.fromARGB(244, 12, 238, 31)
                                              .withOpacity(.8),
                                          const Color.fromARGB(19, 199, 91, 91)
                                              .withOpacity(.8)
                                        ]),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'Transfer ETH',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TransactionPage(
                                        successState: successState),
                                  ),
                                );
                              },
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/block.jpg')),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomRight,
                                        stops: const [
                                          0.3,
                                          0.9
                                        ],
                                        colors: [
                                          const Color.fromARGB(19, 179, 22, 132)
                                              .withOpacity(.8),
                                          const Color.fromARGB(19, 199, 91, 91)
                                              .withOpacity(.8)
                                        ]),
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'Transaction Log',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/stocks.jpg')),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomRight,
                                        stops: const [
                                          0.3,
                                          0.9
                                        ],
                                        colors: [
                                          const Color.fromARGB(19, 56, 108, 114)
                                              .withOpacity(.8),
                                          const Color.fromARGB(19, 135, 56, 56)
                                              .withOpacity(.8)
                                        ]),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'Crypto Stocks',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return Center(
                child: Text('Unknown state: ${state.runtimeType}'),
              );
          }
        },
      ),
    );
  }
}

Widget promoCard(String image, String price) {
  return AspectRatio(
    aspectRatio: 2.62 / 3,
    child: Container(
      margin: const EdgeInsets.only(right: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            stops: const [0.1, 0.9],
            colors: [
              Colors.black.withOpacity(.5),
              Colors.black.withOpacity(.5)
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 15,
              left: 15,
              child: Row(
                children: [
                  Text(price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(
                      width: 8), // Adds some space between the text and image
                  Image.asset("assets/ehereum.png", height: 30, width: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
