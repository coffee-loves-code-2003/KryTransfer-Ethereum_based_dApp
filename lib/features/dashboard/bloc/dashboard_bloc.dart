import 'package:web3dart/web3dart.dart';
import 'dart:async';
import 'dart:convert';

import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dapp/models/transaction_model.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  String privateKey;
  String publicAddress = '';
  String recipientAddress = '0x923875bd113492b0ea5F60ff8abf8e14f3342526';

  DashboardBloc({required this.privateKey}) : super(DashboardInitial()) {
    on<DashboardInitialFetchEvent>(dashboardInitialFetchEvent);
    on<DashBoardDepositEvent>(dashBoardDepositEvent);
    on<DashBoardWithdrawEvent>(dashBoardWithdrawEvent);
    on<DashBoardGetAddress>(dashBoardGetAddress);
    on<TransferFundstoUser>(transferfundstouser);
  }

  final String rpcUrl = "http://10.0.2.2:7545";
  final String socketUrl = "ws://10.0.2.2:7545";

  late ContractAbi abiCode;
  late EthereumAddress contractAddress;
  late EthPrivateKey credentials;
  int balance = 0;
  List<TransactionModel> transactions = [];
  Web3Client? web3client;

  late ContractFunction deposit;
  late ContractFunction withdraw;
  late ContractFunction getBalance;
  late ContractFunction getAllTransactions;
  late ContractFunction transferfund;
  late DeployedContract deployedContract;

  Future<void> dashboardInitialFetchEvent(
      DashboardInitialFetchEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoadingState());
    try {
      web3client = Web3Client(
        rpcUrl,
        http.Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(socketUrl).cast<String>();
        },
      );

      String abiFile = await rootBundle
          .loadString('build/contracts/ExpenseManagerContract.json');
      var jsonDecoded = jsonDecode(abiFile);
      abiCode = ContractAbi.fromJson(
          jsonEncode(jsonDecoded['abi']), 'ExpenseManagerContract');

      contractAddress =
          EthereumAddress.fromHex("0xdAdDb39974d1C8122b174C1124dCf9b39fFF1bD8");
      publicAddress = generatePublicAddress();
      log(publicAddress);
      credentials = EthPrivateKey.fromHex(privateKey);
      deployedContract = DeployedContract(abiCode, contractAddress);

      deposit = deployedContract.function("deposit_crypto");
      withdraw = deployedContract.function("withdraw_crypto");
      getBalance = deployedContract.function("balance_amount");
      getAllTransactions = deployedContract.function("getAllTransaction");
      transferfund = deployedContract.function("transfer_crypto");

      final transactionsData = await web3client!.call(
          contract: deployedContract, function: getAllTransactions, params: []);
      log(transactionsData[0].length.toString());
      List<TransactionModel> trans = [];
      for (int i = 0; i < transactionsData[0].length; i++) {
        int amountInEtherInt =
            (transactionsData[1][i] ~/ BigInt.from(10).pow(18)).toInt();
        TransactionModel transactionModel = TransactionModel(
          transactionsData[0][i].toString(),
          amountInEtherInt,
          transactionsData[2][i].toString(),
          DateTime.fromMicrosecondsSinceEpoch(transactionsData[3][i].toInt()),
        );
        trans.add(transactionModel);
        log('Transaction $i:');
        log('  ID: ${transactionsData[0][i].toString()}');
        log('  Amount: ${transactionsData[1][i].toString()}');
        log('  Reason: ${transactionsData[2][i]}');
      }
      transactions = trans;
      final balanceData = await web3client!.call(
          contract: deployedContract,
          function: getBalance,
          params: [EthereumAddress.fromHex(publicAddress)]);
      balance = balanceData[0].toInt();
      log(balance.toString());
      emit(DashboardSuccessState(transactions: transactions, balance: balance));
    } catch (e) {
      log(e.toString());
      emit(DashboardErrorState());
    }
  }

  Future<void> dashBoardDepositEvent(
      DashBoardDepositEvent event, Emitter<DashboardState> emit) async {
    try {
      await web3client!.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: deployedContract,
              function: deposit,
              parameters: [
                BigInt.from(event.transactionModel.amount),
                event.transactionModel.reason
              ],
              value: EtherAmount.inWei(
                  BigInt.from(event.transactionModel.amount))),
          chainId: 1337,
          fetchChainIdFromNetworkId: false);
      // EtherAmount balance1 =
      //     await web3client!.getBalance(EthereumAddress.fromHex(publicAddress));
      // log(publicAddress);

      // // Log the balance
      // log('Balance: ${balance1.getInEther} ETH');
      // final balanceData = await web3client!.call(
      //     contract: deployedContract,
      //     function: getBalance,
      //     params: [EthereumAddress.fromHex(publicAddress)]);
      // balance = balanceData[0].toInt();
      // log(balance.toString());
      // emit(DashboardSuccessState(transactions: transactions, balance: balance));
    } catch (e) {
      emit(DashboardErrorState());
    }
  }

  Future<void> dashBoardWithdrawEvent(
      DashBoardWithdrawEvent event, Emitter<DashboardState> emit) async {
    try {
      await web3client!.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: deployedContract,
              function: withdraw,
              parameters: [
                event.transactionModel.amount,
                event.transactionModel.reason
              ]));
      emit(DashboardSuccessState(transactions: transactions, balance: balance));
    } catch (e) {
      log(e.toString());
      emit(DashboardErrorState());
    }
  }

  Future<void> transferfundstouser(
      TransferFundstoUser event, Emitter<DashboardState> emit) async {
    try {
      await web3client!.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: deployedContract,
          function: transferfund,
          parameters: [
            EthereumAddress.fromHex(event.transactionModel.address),
            // BigInt.from(event.transactionModel.amount),
            event.transactionModel.reason
          ],
          value: EtherAmount.fromUnitAndValue(
              EtherUnit.ether, event.transactionModel.amount),
        ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false,
      );
      emit(DashboardSuccessState(transactions: transactions, balance: balance));
    } catch (e) {
      log('hello');
      log(e.toString());
      emit(DashboardErrorState());
    }
  }

  FutureOr<void> dashBoardGetAddress(
      DashBoardGetAddress event, Emitter<DashboardState> emit) async {}

  String generatePublicAddress() {
    try {
      EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);

      EthereumAddress publicAddress = credentials.address;

      return publicAddress.hex;
    } catch (e) {
      return 'Invalid private key!';
    }
  }
}
