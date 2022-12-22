import 'package:flutter/material.dart';
import 'package:friend_ai/main.dart';
import 'package:friend_ai/model/category.dart';
import 'package:friend_ai/provider/storage_provider.dart';
import 'package:friend_ai/repository/category_repository.dart';

class CategoryElement extends StatefulWidget {
  final String? search;
  final SearchController? controller;
  final Function(String val)? onTapItem;
  const CategoryElement(
      {super.key, this.search, this.controller, this.onTapItem});

  @override
  State<CategoryElement> createState() => _CategoryElementState(controller);
}

class _CategoryElementState extends State<CategoryElement> {
  _CategoryElementState(SearchController? _controller) {
    if (_controller != null) {
      _controller.callFilter = filterSearch;
    }
  }

  List<Category> categories = [];
  List<Category> searchedCategories = [];
  String? token;
  bool loading = false;

  void getDatas() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
    }
    if (token != null) {
      await CategoryRepository.getCategories(token!).then((value) {
        setState(() {
          categories = value;
          searchedCategories = value;
        });
      });
    }
    setState(() {
      loading = false;
    });
  }

  void getToken() async {
    setState(() {
      loading = true;
    });
    await StorageProvider.getLocalToken().then((value) {
      if (value != null) {
        setState(() {
          token = value;
        });
      }
    });
    if (token == null) {
      await StorageProvider.getTempToken().then((value) {
        if (value != null) {
          setState(() {
            token = value;
          });
        }
      });
    }
    getDatas();
  }

  void filterSearch() {
    var searcheds = categories
        .where((element) =>
            (element.name != null &&
                element.name!
                    .toLowerCase()
                    .contains(widget.search!.toLowerCase())) ||
            (element.description != null &&
                element.description!
                    .toLowerCase()
                    .contains(widget.search!.toLowerCase())))
        .toList();
    setState(() {
      searchedCategories = searcheds;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: RefreshIndicator(
              onRefresh: () async {
                getToken();
              },
              child: (!loading)
                  ? searchedCategories.length == 0
                      ? ListView(
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text("No categories found"),
                              ),
                            )
                          ],
                        )
                      : ListView.builder(
                          itemCount: searchedCategories.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(searchedCategories[index].name!),
                              subtitle:
                                  Text(searchedCategories[index].description!),
                              onTap: () {
                                if (widget.onTapItem != null) {
                                  widget.onTapItem!(
                                      searchedCategories[index].name!);
                                }
                              },
                            );
                          },
                        )
                  : SizedBox(
                      height: 400,
                      width: 200,
                    ),
            )),
        (loading)
            ? Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : SizedBox()
      ],
    );
  }
}
