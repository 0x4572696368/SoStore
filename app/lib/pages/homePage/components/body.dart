import 'package:app/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_skeleton/loading_skeleton.dart';

import 'categories.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List dataList = List();
  bool isLoading = false;
  int pageCount = 1;
  ScrollController _scrollController;
  List listData;
  bool loadData = false;
  bool loadMoreData = true;
  int lasted = 0;
  int lastedTemp = 1;
  Future getProducts(int idp) async {
    setState(() {
      loadMoreData = false;
    });
    try {
      Map row;
      Response res;
      var dio = Dio();
      res = await dio.get(
        apiGetProducts,
        queryParameters: {'idp': idp},
      ).timeout(Duration(seconds: 5), onTimeout: () {
        return null;
      });
      print(res.data);
      if (res.statusCode == 200) {
        row = res.data;
        setState(() {
          try {
            if (idp == 0) {
              listData.clear();
              dataList.clear();
            }
          } catch (e) {}
          listData = row['data'];
          lasted = int.parse(row['latest']);
          loadData = true;
          loadMoreData = true;
          addItemIntoLisT(1);
          print(listData.toString());
        });
      } else {
        print("Error: statusCode");
        setState(() {
          loadMoreData = true;
        });
      }
    } catch (e) {
      // print(e);
      print("Error: dio 'no get data");
      setState(() {
        loadMoreData = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProducts(lasted);
    // addItemIntoLisT(1);
    _scrollController = new ScrollController(initialScrollOffset: 0.5)..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20),
        //   child: (Text(
        //     "WOMEN",
        //     style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
        //   )),
        // ),
        Categories(),
        Expanded(
          //     Padding(
          //   padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 2),
          //   child: GridView.builder(
          //       physics: NeverScrollableScrollPhysics(),
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: 2, childAspectRatio: 0.80, mainAxisSpacing: 5, crossAxisSpacing: 5),
          //       itemCount: 8,
          //       itemBuilder: (context, index) {
          //         return LoadingSkeleton(
          //           width: 100,
          //           height: 100,
          //           colors: [
          //             Colors.grey[200],
          //             Colors.white,
          //             Colors.grey[300],
          //           ],
          //           animationDuration: 1000,
          //         );
          //       }),
          // )
          child: loadData == true
              ? RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      lasted = 0;
                      lastedTemp = 1;
                    });
                    await getProducts(lasted);
                  },
                  child: GridView.count(
                      shrinkWrap: true,
                      addAutomaticKeepAlives: true,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: dataList.map((e) {
                        // return Card(
                        //   child: Column(
                        //     // physics: const NeverScrollableScrollPhysics(),
                        //     children: [
                        //       SizedBox(
                        //         height: 100,
                        //         // child: Image(image: NetworkImage(e["image"])),
                        //         child: CachedNetworkImage(
                        //           imageUrl: photos + e["images"][0]["Photo"],
                        //           progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                        //             child: Center(
                        //               child: SizedBox(
                        //                 height: 20,
                        //                 width: 20,
                        //                 child: CircularProgressIndicator(value: downloadProgress.progress),
                        //               ),
                        //             ),
                        //           ),
                        //           errorWidget: (context, url, error) => Icon(Icons.error),
                        //           fit: BoxFit.cover,
                        //           width: 1000,
                        //         ),
                        //       ),
                        //       Text("id: ${e['idp']}"),
                        //       // Text("numero 1 ${e['title']}"),
                        //       // Text("numero 1 ${e['price']}"),
                        //       // Text("numero 1 ${e['id']}"),
                        //       // Text("numero 1 ${e['id']}"),
                        //     ],
                        //   ),
                        // );

                        return Card(
                          child: GestureDetector(
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                        title: Text(e['name']),
                                        content: Column(
                                          children: [
                                            Text("Descripcion:  ${e['description']}"),
                                            Text("Precio: S/. ${e['price']}"),
                                            Text("Stock:  ${e['stock']}"),
                                          ],
                                        ),
                                      ));
                            },
                            onDoubleTap: () {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: CachedNetworkImage(
                                      width: double.infinity,
                                      imageUrl: photos + e["images"][0]["Photo"],
                                      progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                        child: Center(
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(value: downloadProgress.progress),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text("${e['name']}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    "S/.${e['price']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // color: basicColor
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 2),
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.80, mainAxisSpacing: 5, crossAxisSpacing: 5),
                      itemCount: 8,
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
                        );
                      }),
                ),
        ),
        loadMoreData == false
            ? Container(
                color: Colors.white10,
                height: 50,
                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("comes to bottom $isLoading");
        if (lastedTemp != lasted) {
          isLoading = true;

          if (isLoading) {
            print("RUNNING LOAD MORE");
            getProducts(lasted);
            lastedTemp = lasted;
          }
        }
      });
    }
  }

  ////ADDING DATA INTO ARRAYLIST
  void addItemIntoLisT(var pageCount) {
    // for (int i = (pageCount * 100) - 100; i < pageCount * 100; i++) {
    //   dataList.add(i);
    //   isLoading = false;
    // }

    for (var i = 0; i < listData.length; i++) {
      dataList.add(listData[i]);
    }
    isLoading = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
