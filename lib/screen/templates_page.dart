
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Templates extends StatefulWidget {

  @override
  _TemplatesState createState() => _TemplatesState();
}

enum TypeHouse {IndustrialBuilding, House, Apartment}

class _TemplatesState extends State<Templates> {

  final _formKey = GlobalKey<FormState>();
  double _height, _width, _fixedPadding;

  TextEditingController _textEditingFire = TextEditingController();
  int _typeFire = 0;
  TypeHouse _typeHouse;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;
    print(_width);
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Шаблон о пораже"),
        actions: <Widget>[
        ],
      ),
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
//                  width: _width,
//                  height: _height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
                          child: Container(
                            width: _width-(_fixedPadding*2),
                            child: _textFormField(_textEditingFire, "Текстовое поле 1"),
                          )
                      ),
                      _typeFireWidget(_typeFire, (int value){
                        setState(() {
                          _typeFire = value;
                        });
                      }),
                      Padding(
                        padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
                        child: _typeHouseWidget(_typeHouse, (TypeHouse value) {
                          setState(() {
                            _typeHouse = value;
                          });
                        }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
                        child: RaisedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              Scaffold.of(context)
                                  .showSnackBar(SnackBar(content: Text('Processing Data')));
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          );
        },
      )
    );
  }

  static Widget _typeFireWidget(int contoller, onChanged) {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 10.00,),
          child: Text(
            'Степень пожара:', style: TextStyle(fontSize: 20.0),
          ),
        ),
        RadioListTile(
          title: const Text('1'),
          value: 0,
          groupValue: contoller,
          onChanged: onChanged,
        ),
        RadioListTile(
          title: const Text('2'),
          value: 1,
          groupValue: contoller,
          onChanged: onChanged,
        ),
      ],
    );
  }

  static Widget _typeHouseWidget(TypeHouse contoller, onChanged) {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 10.00,),
          child: Text(
            'Объект', style: TextStyle(fontSize: 20.0),
          ),
        ),
        DropdownButton<TypeHouse>(
          value: contoller,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
              color: Colors.deepPurple
          ),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          items: TypeHouse.values.map((TypeHouse typeHouse) {
            String nameHouse;
            switch (typeHouse) {
              case TypeHouse.IndustrialBuilding:
                nameHouse = "Промышленное здание";
                break;
              case TypeHouse.House:
                nameHouse = "Частный дом";
                break;
              case TypeHouse.Apartment:
                nameHouse = "Квартира";
                break;
            }

            return DropdownMenuItem<TypeHouse>(
              value: typeHouse,
              child: Text(nameHouse),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  static Widget  _textFormField(
      TextEditingController _textEditingController, String _labelText) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: _labelText,
      ),
      controller: _textEditingController,
      showCursor: true,
      cursorColor: Colors.blue,
      keyboardType: TextInputType.text,
      cursorWidth: 3.0,
      style: TextStyle(color: Colors.black),
//        validator: (value) {
//          if (value.isEmpty) {
//            return 'Please enter some text';
//          }
//          return null;
//        },
    );
  }
}