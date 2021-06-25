import 'dart:io';
import 'package:app/functions.dart';
import 'package:flutter/material.dart';

class FlPiker extends StatefulWidget {
  FlPiker({Key key}) : super(key: key);

  @override
  _FlPikerState createState() => _FlPikerState();
}

class _FlPikerState extends State<FlPiker> {
  String resUpload = '-';
  String upload = '-';
  List<File> files = [];
  bool view = false;
  final fn = Fn();
  Future getFilesTest() async {
    const data = [
      ["titulo", "Erich"],
      ["apellido", "Echevarria"]
    ];

    List<File> fl = await fn.getFiles();
    if (fl.length > 0) {
      List<File> flx = [];
      for (var i = 0; i < fl.length; i++) {
        File file_com = await fn.testCompressAndGetFile(fl[i].path);
        print(fl[i].path);
        print(file_com.path);
        flx.add(file_com);
      }
      fl.addAll(flx);

      setState(() {
        files = fl;
        view = true;
      });

      await fn.setData(data, files, response: (String text) {
        setState(() {
          resUpload = text;
        });
      }, upload: (value) {
        setState(() {
          upload = value;
        });
      });
    }
  }

  Future deleteItem(int item) async {
    List<File> tmpfiles = files;
    tmpfiles.removeAt(item);
    setState(() {
      files = tmpfiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            view == true
                ? new Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: files.length,
                        itemBuilder: (BuildContext context, int i) {
                          return new GestureDetector(
                            onTap: () {
                              deleteItem(i);
                            },
                            child: new Image.file(
                              files[i],
                              width: 100,
                              height: 100,
                              scale: 0.5,
                            ),
                          );
                        }),
                  )
                : Text("none"),
            Text(upload),
            Text(resUpload)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // getFiles();
            getFilesTest();
          },
        ),
      ),
    );
  }
}
