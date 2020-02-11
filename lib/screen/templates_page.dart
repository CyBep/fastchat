
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Templates extends StatefulWidget {

  @override
  _TemplatesState createState() => _TemplatesState();
}

enum TypeHouse {IndustrialBuilding, House, Apartment}
enum Type {Text, Select}

class Field {
  Type type;
  String Name;
  int value;
  String result;
  List<String> _list;
  TextEditingController textEditingController;

  setStateResultText(value){
    this.result = value;
  }
  setStateResultSelect(value){
    this.value = value;
    this.result = this._list[value];
  }
}

class FieldText extends Field {
  TextEditingController textEditingController = TextEditingController();

  FieldText(String Name) {
    this.type = Type.Text;
    this.Name = Name;
    this.textEditingController = textEditingController;
  }
}
class FieldSelect extends Field {
  FieldSelect(String Name, List<String> list) {
    this.type = Type.Select;
    this.Name = Name;
    this._list = list;
  }
}

class _TemplatesState extends State<Templates> {

  final _formKey = GlobalKey<FormState>();
  double _height, _width, _fixedPadding;

  TextEditingController _textEditingFire = TextEditingController();
  List<Field> listEditingController = [];
  int _typeFire = 0;
  TypeHouse _typeHouse = TypeHouse.IndustrialBuilding;

  @override
  void initState() {
    super.initState();

    listEditingController.add(new FieldText("Адрес"));
    listEditingController.add(new FieldSelect("Ранг пожара", ["Нет", "1", "1-бис", "2", "3", "4"]));
    listEditingController.add(new FieldText("Этажность дома"));
    listEditingController.add(new FieldSelect("Степень огнестойкости", ["1","2","3","4","5"]));
    listEditingController.add(new FieldText("Площадь пожара м2"));
    listEditingController.add(new FieldText("На каком этаже пожар"));
    listEditingController.add(new FieldSelect("Что горит", ["Конструкция","Мебель","Вещи б/у","Мебель и вещи б/у","Бытовая техника"]));
    listEditingController.add(new FieldSelect("Наличие угрозы", ["Есть","Нет"]));
    listEditingController.add(new FieldSelect("Эвакуация", ["Требуется","Не требуется"]));
    listEditingController.add(new FieldText("Что подано на тушение"));
    listEditingController.add(new FieldText("Пострадавшие"));
    listEditingController.add(new FieldText("Погибшие"));
    listEditingController.add(new FieldSelect("ГДЗС", ["Нет","1","2","3 и более"]));
    listEditingController.add(new FieldText("Хозяин"));
  }

  Widget __listsForm(BuildContext context) {
    return ListView.builder(
      itemCount: listEditingController.length,
      itemBuilder: (context, index) {
        switch(listEditingController[index].type) {
            case Type.Text:
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: _fixedPadding, left: _fixedPadding),
                    child: Text(
                      listEditingController[index].Name + ":",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: _fixedPadding),
                      child: Container(
                        width: _width - (_fixedPadding),
                        child: _textFormField(
                            listEditingController[index].textEditingController,
                            ""),
                      )
                  ),
                ],
              );
              break;
            case Type.Select:
              print(index);
              return _radioWidget(listEditingController[index], context);
              break;
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Шаблон \"Квартира\""),
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
                  width: _width,
                  height: _height-80,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: _height-150,
                        child: __listsForm(context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              List<String> _template = [];
                              listEditingController.forEach((field) {
                                if (field.type == Type.Text)
                                  _template.add(field.Name+": "+field.textEditingController.text);
                                else
                                  _template.add(field.Name+": "+field.result);
                              });
//                              _template.add("Степень пожара: "+_typeFire.toString());
//
//                              String nameHouse;
//                              switch (_typeHouse) {
//                                case TypeHouse.IndustrialBuilding:
//                                  nameHouse = "Промышленное здание";
//                                  break;
//                                case TypeHouse.House:
//                                  nameHouse = "Частный дом";
//                                  break;
//                                case TypeHouse.Apartment:
//                                  nameHouse = "Квартира";
//                                  break;
//                              }
//                              _template.add("Объект: "+nameHouse);
                              Navigator.pop(context, _template);
//                              Scaffold.of(context)
//                                  .showSnackBar(SnackBar(content: Text('Processing Data')));
                            }
                          },
                          child: Text('Отправить'),
                        ),
                      ),
                    ],
                  )
//                  child: Column(
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
//                        child: Text(
//                          "Адрес:", style: TextStyle(fontSize: 20.0),
//                        ),
//                      ),
//                      Padding(
//                          padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
//                          child: Container(
//                            width: _width-(_fixedPadding*2),
//                            child: _textFormField(_textEditingFire, "Текстовое поле 1"),
//                          )
//                      ),
//                      _typeFireWidget(_typeFire, (int value){
//                        setState(() {
//                          _typeFire = value;
//                        });
//                      }),
//                      Padding(
//                        padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
//                        child: _typeHouseWidget(_typeHouse, (TypeHouse value) {
//                          setState(() {
//                            _typeHouse = value;
//                          });
//                        }),
//                      ),
//                      Padding(
//                        padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
//                        child: RaisedButton(
//                          onPressed: () {
//                            // Validate returns true if the form is valid, or false
//                            // otherwise.
//                            if (_formKey.currentState.validate()) {
//                              List<String> _template = [];
//                              _template.add("Адрес: "+_textEditingFire.text);
//                              _template.add("Степень пожара: "+_typeFire.toString());
//
//                              String nameHouse;
//                              switch (_typeHouse) {
//                                case TypeHouse.IndustrialBuilding:
//                                  nameHouse = "Промышленное здание";
//                                  break;
//                                case TypeHouse.House:
//                                  nameHouse = "Частный дом";
//                                  break;
//                                case TypeHouse.Apartment:
//                                  nameHouse = "Квартира";
//                                  break;
//                              }
//                              _template.add("Объект: "+nameHouse);
//                              Navigator.pop(context, _template);
////                              Scaffold.of(context)
////                                  .showSnackBar(SnackBar(content: Text('Processing Data')));
//                            }
//                          },
//                          child: Text('Отправить'),
//                        ),
//                      ),
//                    ],
//                  ),
                ),
              ),
            )
          );
        },
      )
    );
  }

  static Widget _radioWidget(Field field, BuildContext context) {
    double _height = 50*field._list.length.toDouble();
    double _width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 10.00,),
          child: Text(
            field.Name+':', style: TextStyle(fontSize: 20.0),
          ),
        ),
        Container(
          width: _width,
          height: _height,
          child: ListView.builder(
              itemCount: field._list.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  title: Text(field._list[index]),
                  value: index,
                  groupValue: field.value,
                  onChanged: (value){
                    field.setStateResultSelect(value);
                  },
//              onChanged: (String string){
//                setState(() {
//                  field.result = string;
//                });
//              },
                );
              }
          ),
        )
//        RadioListTile(
//          title: const Text('2'),
//          value: 1,
//          groupValue: contoller,
//          onChanged: onChanged,
//        ),
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