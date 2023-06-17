import 'dart:convert';

import 'package:cryptotracker/widgets/coincard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/coinmodel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<CoinModel>>getCoinApi()async{
    var request = http.Request('GET', Uri.parse('https://webhook.site/83a1d7ab-2193-4910-9a82-a21322ce5055'));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      List<CoinModel> coins = coinModelFromJson(await response.stream.bytesToString());

      return coins;
    }
    else {
      throw Exception(response.reasonPhrase);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(CupertinoIcons.back), color: Colors.grey.shade900),
        backgroundColor: Colors.grey.shade300,
        title: Text(
          "CRYPTO-TRACKER",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey.shade900),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getCoinApi(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                return  CoinCard(
                  name: snapshot.data![index].name,
                  symbol: snapshot.data![index].symbol,
                  imageUrl:
                  snapshot.data![index].image,
                  price: snapshot.data![index].currentPrice,
                  change: snapshot.data![index].priceChange24H,
                  changePercentage: 2.6,
                );
              }
            );
          }
        }
      ),
    );
  }
}


