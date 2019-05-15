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
        primaryColor: Color(0xff3c00ca),
        primaryColorDark: Color(0xff000098),
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
  TextEditingController fromCurrencyController =
  new TextEditingController(text: "0.00");
  TextEditingController toCurrencyController = new TextEditingController();
  double fromValue = 0;
  String fromValueString = "0";
  double rate = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    var height = size.height;
    var width = size.width;

    TextStyle numberPadTextStyle = new TextStyle(
        fontSize: 42.0, color: Colors.white, fontWeight: FontWeight.w100);

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme
          .of(context)
          .primaryColorDark,
        title: Text("Currency Xchange".toUpperCase(),
          style: TextStyle(letterSpacing: 2.0),),
        centerTitle: true,
      ),
      body: Container(
        color: Theme
            .of(context)
            .primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("USD"),
                  ),
                  Text("${fromValue.toString()}",
                      style: TextStyle(fontSize: 72.0)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("INR"),
                  ),
                  Text("${(rate * fromValue).toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 72.0)),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                color: Theme
                    .of(context)
                    .primaryColorDark,
                height: height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        MaterialButton(
                            onPressed: () {
                              numberTap("7");
                            },
                            child: Text(
                              "7",
                              style: numberPadTextStyle,
                            )),
                        MaterialButton(
                            onPressed: () {
                              numberTap("8");
                            },
                            child: Text(
                              "8",
                              style: numberPadTextStyle,
                            )),
                        MaterialButton(
                            onPressed: () {
                              numberTap("9");
                            },
                            child: Text(
                              "9",
                              style: numberPadTextStyle,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        MaterialButton(
                            onPressed: () {
                              numberTap("4");
                            },
                            child: Text(
                              "4",
                              style: numberPadTextStyle,
                            )),
                        MaterialButton(
                            onPressed: () {
                              numberTap("5");
                            },
                            child: Text(
                              "5",
                              style: numberPadTextStyle,
                            )),
                        MaterialButton(
                            onPressed: () {
                              numberTap("6");
                            },
                            child: Text(
                              "6",
                              style: numberPadTextStyle,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        MaterialButton(
                            onPressed: () {
                              numberTap("1");
                            },
                            child: Text(
                              "1",
                              style: numberPadTextStyle,
                            )),
                        MaterialButton(
                            onPressed: () {
                              numberTap("2");
                            },
                            child: Text(
                              "2",
                              style: numberPadTextStyle,
                            )),
                        MaterialButton(
                            onPressed: () {
                              numberTap("3");
                            },
                            child: Text(
                              "3",
                              style: numberPadTextStyle,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        MaterialButton(
                            onPressed: () {
                              numberTap(".");
                            },
                            child: Text(
                              ".",
                              style: numberPadTextStyle,
                            )),
                        MaterialButton(
                            onPressed: () {
                              numberTap("0");
                            },
                            child: Text(
                              "0",
                              style: numberPadTextStyle,
                            )),
                        MaterialButton(
                            onPressed: () {
                              backspaceTap();
                            },
                            child: Icon(
                              Icons.backspace,
                            )),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
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
    setState(() {
      rate = currency.iNR / currency.uSD;
    });

    print(rate);
  }

  void numberTap(String numberString) {
    double from = double.parse(fromValueString);
    if (from == 0) {
      double numberTapped = double.parse(numberString);
      from += numberTapped;
      fromValueString = numberString;
    } else if (numberString == ".") {
      if (fromValueString.contains(".")) {} else {
        fromValueString += ".";
      }
    } else {
      fromValueString += numberString;
    }
    setState(() {
      fromValue = (fromValueString.endsWith(".")
          ? double.parse(fromValueString + "0")
          : double.parse(fromValueString));
    });

    print(fromValueString);
  }

  void backspaceTap() {
    int len = fromValueString.length;
    if (len > 1) {
      fromValueString = fromValueString.substring(0, len - 1);
    } else {
      fromValueString = "0";
    }
    setState(() {
      fromValue = (fromValueString.endsWith(".")
          ? double.parse(fromValueString + "0")
          : double.parse(fromValueString));
    });
    print(fromValueString);
  }
}
