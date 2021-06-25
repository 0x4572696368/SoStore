import 'dart:io';
import 'dart:math';
import 'package:app/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Fn {
  Future getFiles() async {
    List<File> files = [];
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: formats);
    if (result != null) {
      files.clear();
      files = result.paths.map((path) => File(path)).toList();
      return files;
    } else {
      return []; // User canceled the picker
    }
  }

  Future setData(data, List<File> files, {Function(String value) upload, Function response}) async {
    var formData = new FormData();
    for (var i = 0; i < data.length; i++) {
      formData.fields.add(MapEntry(data[i][0], data[i][1]));
    }
    for (var i = 0; i < files.length; i++) {
      formData.files
          .add(MapEntry("file[]", MultipartFile.fromFileSync(files[i].path, filename: basename(files[i].path))));
    }
    Response res = await Dio().post(apiSetProducts, data: formData, onSendProgress: (int sent, int total) {
      upload(((sent / total) * 100).toStringAsFixed(2) + "%");
    });
    response(res.toString());
  }

  Future<File> testCompressAndGetFile(String file) async {
    var time = DateTime.now().microsecondsSinceEpoch.toString();
    final dir = Directory.systemTemp;
    String targetPath = dir.absolute.path + "/" + time + getRandomString(20) + ".jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file,
      targetPath,
      quality: 90,
      format: CompressFormat.jpeg,
      minHeight: 1080,
      minWidth: 1080,
    );
    return result;
  }

  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
