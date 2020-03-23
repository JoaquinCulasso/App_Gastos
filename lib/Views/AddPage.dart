import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/Controllers/category_selection_widget.dart';
import 'package:expenses/State/login_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String category;
  //double realValue = 0;
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Category',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelector(),
        _currentValue(),
        _numpad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelector() {
    return Container(
      height: 80,
      child: CategorySelectionWidget(
        categories: {
          "Shopping": Icons.shopping_cart,
          "Alcohol": FontAwesomeIcons.beer,
          "Fast Food": FontAwesomeIcons.hamburger,
          "Bills": FontAwesomeIcons.wallet,
        },
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
    double realValue = value / 100.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Text(
        "\$${realValue.toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: 50.0,
          color: Colors.blueAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _num(String number, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (number == ',') {
            value = value * 100;
          } else {
            value = value * 10 + int.parse(number);
          }
        });
      },
      child: Container(
        height: height,
        child: Center(
            child: Text(
          number,
          style: TextStyle(
            fontSize: 40,
            color: Colors.grey,
          ),
        )),
      ),
    );
  }

  Widget _numpad() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.biggest.height / 4;
        return Table(
          border: TableBorder.all(
            color: Colors.grey,
            width: 1.0,
          ),
          children: [
            TableRow(children: [
              _num("1", height),
              _num("2", height),
              _num("3", height),
            ]),
            TableRow(
              children: [
                _num("4", height),
                _num("5", height),
                _num("6", height),
              ],
            ),
            TableRow(
              children: [
                _num("7", height),
                _num("8", height),
                _num("9", height),
              ],
            ),
            TableRow(
              children: [
                _num(",", height),
                _num("0", height),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      value = value ~/ 10;
                    });
                  },
                  child: Container(
                    height: height,
                    child: Center(
                      child: Icon(
                        Icons.backspace,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _submit() {
    return Builder(
      builder: (BuildContext context) {
        return Hero(
          tag: "add_button",
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: MaterialButton(
              child: Text(
                "Agregar Gasto",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                var user = Provider.of<LoginState>(context, listen: false)
                    .currentUser();
                if (value > 0 && category != null) {
                  Firestore.instance
                      .collection('users')
                      .document(user.uid)
                      .collection('expenses')
                      .document()
                      .setData({
                    "category": category,
                    "value": value / 100,
                    "month": DateTime.now().month,
                    "day": DateTime.now().day,
                  });
                  Navigator.of(context).pop();
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Selecciona un valor mayor a 0 y una categoria"),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
