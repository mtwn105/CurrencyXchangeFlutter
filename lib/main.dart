import 'dart:convert';

import 'package:currency_xchange_flutter/currencyModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

final String apiKey = "41c2444c883b95732d2cc7c6cb1f1125";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Xchange',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController fromCurrencyController = new TextEditingController(text: "0.00");
  TextEditingController toCurrencyController = new TextEditingController();
  double rate = 0.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Xchange"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              controller: fromCurrencyController,
            ),
            Text("Rs. ${rate*double.parse(fromCurrencyController.text)}"),
            FlatButton(
              onPressed: getData,
              child: Text("Convert"),
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }

  Future<Null> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://data.fixer.io/api/latest?access_key=" + apiKey),
        headers: {"Accept": "application/json"});
    var data = json.decode(response.body);
    CurrencyModel currencyModel = CurrencyModel.fromJson(data);
    Currency currency = currencyModel.rates;
    double base = currency.eUR.ceilToDouble();
    setState(() {
      rate = currency.iNR / currency.uSD;
    });
    print(rate);
  }
}
