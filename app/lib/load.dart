import 'package:app/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Load extends StatefulWidget {
  Load({Key key}) : super(key: key);

  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> {
  List dataList = List();
  bool isLoading = false;
  int pageCount = 1;
  ScrollController _scrollController;
  List listData;

  bool loadData = false;
  bool loadMoreData = true;
  Future getProducts() async {
    setState(() {
      loadMoreData = false;
    });
    try {
      Map row;
      Response res;
      var dio = Dio();
      res = await dio.get(apiGetProducts);
      if (res.statusCode == 200) {
        row = res.data;
        setState(() {
          listData = row['data'];
          loadData = true;
          loadMoreData = true;
          addItemIntoLisT(1);
          print(listData.toString());
        });
      } else {
        print("Error xxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getProducts();
    // addItemIntoLisT(1);
    _scrollController = new ScrollController(initialScrollOffset: 0.5)..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    // dataList.forEach((url) {
    //   precacheImage(NetworkImage(url), context);
    // });
    // precacheImage(Image.network("",fit: BoxFit.cover),context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List"),
      ),
      body: loadData == true
          ? GridView.count(
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
                return Card(
                  child: Column(
                    // physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 100,
                        // child: Image(image: NetworkImage(e["image"])),
                        child: CachedNetworkImage(
                          imageUrl: e["image"],
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
                          fit: BoxFit.cover,
                          width: 1000,
                        ),
                      ),
                      Text("id: ${e['id']}"),
                      // Text("numero 1 ${e['title']}"),
                      // Text("numero 1 ${e['price']}"),
                      // Text("numero 1 ${e['id']}"),
                      // Text("numero 1 ${e['id']}"),
                    ],
                  ),
                );
              }).toList())
          : Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          getProducts();
        },
      ),
      bottomSheet: loadMoreData == false
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
          : null,
    );
  }

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("comes to bottom $isLoading");
        isLoading = true;

        if (isLoading) {
          print("RUNNING LOAD MORE");
          // pageCount = pageCount + 1;
          // addItemIntoLisT(pageCount);
          getProducts();
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
