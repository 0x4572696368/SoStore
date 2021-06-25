import 'package:flutter/material.dart';
import 'package:loading_skeleton/loading_skeleton.dart';
import 'dart:io';
import 'package:app/functions.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _cName = new TextEditingController();
  final TextEditingController _cPrice = new TextEditingController();
  final TextEditingController _cDesciption = new TextEditingController();
  final TextEditingController _cStock = new TextEditingController();

  final fn = Fn();
  bool loading = false;
  bool dataContent = false;
  List<File> files = [];
  Future getFilesTest() async {
    setState(() {
      loading = true;
    });
    List<File> fl = await fn.getFiles();
    if (fl.length > 0) {
      List<File> flx = [];
      for (var i = 0; i < fl.length; i++) {
        File path = await fn.testCompressAndGetFile(fl[i].path);
        flx.add(path);
      }
      setState(() {
        files.addAll(flx);
        loading = false;
        if (files.length > 0) {
          dataContent = true;
        } else {
          dataContent = false;
        }
      });
    } else {
      setState(() {
        loading = false;
        dataContent = false;
      });
    }
  }

  Future deleteItem(int item) async {
    List<File> tmpfiles = files;
    tmpfiles.removeAt(item);
    setState(() {
      files = tmpfiles;
      if (files.length > 0) {
        dataContent = true;
      } else {
        dataContent = false;
      }
    });
  }

  String resUpload = "";
  String upload = "";

  Future send() async {
    setState(() {
      resUpload = "";
      upload = "";
    });
    if (files.length > 0) {
      List data = [
        ["name", _cName.text],
        ["price", _cPrice.text],
        ["stock", _cStock.text],
        ["description", _cDesciption.text],
      ];
      await fn.setData(data, files, response: (String text) {
        setState(() {
          resUpload = text;
        });
      }, upload: (value) {
        setState(() {
          upload = value;
        });
      });
      setState(() {
        _cName.clear();
        _cPrice.clear();
        _cDesciption.clear();
        _cStock.clear();
        files = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("NUEVO PRODUCTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                ),
              ),
              inputProduct(_cName, "Nombre del producto", TextInputType.text, Icons.card_giftcard),
              inputProduct(_cPrice, "Precio del producto", TextInputType.number, Icons.attach_money),
              inputProduct(_cStock, "Stock del producto", TextInputType.number, Icons.app_registration),
              inputProduct(_cDesciption, "Descripcion del producto", TextInputType.multiline, Icons.details_outlined),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                ),
                onPressed: () {
                  getFilesTest();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.add_a_photo),
                      ),
                      Text("AGREGAR FOTOS")
                    ],
                  ),
                ),
              ),
              dataContent == true
                  ? SizedBox(
                      height: 150,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: files.length,
                          itemBuilder: (BuildContext context, int i) {
                            return new GestureDetector(
                              onTap: () {
                                deleteItem(i);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Image.file(
                                  files[i],
                                  width: 100,
                                  height: 100,
                                  scale: 0.5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                    )
                  : SizedBox(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(

                            // physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, childAspectRatio: 0.76, mainAxisSpacing: 5, crossAxisSpacing: 5),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return LoadingSkeleton(
                                width: 100,
                                height: 100,
                                colors: [
                                  Colors.grey[200],
                                  Colors.white,
                                  Colors.grey[300],
                                ],
                                animationDuration: 1000,
                                child: Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: loading == true ? CircularProgressIndicator() : null,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                ),
                onPressed: () {
                  // print(_cName.text);
                  // print(_cPrice.text);
                  // print(_cStock.text);
                  // print(_cDesciption.text);
                  send();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.send)), Text("ENVIAR")],
                  ),
                ),
              ),
              Text(upload),
              Text(resUpload),
            ],
          ),
        ),
      ),
    ));
  }

  Padding inputProduct(TextEditingController controller, String hint, TextInputType control, IconData ic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
          keyboardType: control,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                      Color.fromRGBO(60, 60, 60, 1),
                      Color.fromRGBO(32, 32, 32, 1),
                    ]),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    ic,
                    color: Colors.white,
                  )),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          )),
    );
  }
}
