import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as inapp;
import 'package:friend_ai/component/keep_page_alive.dart';
import 'package:friend_ai/page/account_page.dart';
import 'package:friend_ai/page/category_element.dart';
import 'package:friend_ai/page/character_list_element.dart';
import 'package:friend_ai/page/chat_history_element.dart';
import 'package:friend_ai/provider/storage_provider.dart';
import 'package:friend_ai/utility/utility_helper.dart';
import 'package:restart_app/restart_app.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await inapp.InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MainNavigator(),
    );
  }
}

class SearchController {
  late void Function() callFilter;
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  final List<TextEditingController> _searchQueryController = [
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController()
  ];
  List<bool> _isSearching = [false, false, false];
  List<String> searchQuery = ["", "", ""];
  final List<SearchController> searchController = [
    new SearchController(),
    new SearchController(),
    new SearchController()
  ];
  TabController? tabController;
  int pageIndex = 1;
  //array title
  final List<String> _listTitle = [
    "Chat History",
    "Character List",
    "Category",
  ];

  void logout() async {
    UtilityHelper.showAlertDialogLoading(
        context, "Loading...", "Logout account...");
    await StorageProvider.deleteAll();
    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.of(context).pop();
      Restart.restartApp();
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController[pageIndex],
      autofocus: true,
      onSubmitted: (query) {
        updateSearchQuery(query);
      },
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching[pageIndex]) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _stopSearching();
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
      PopupMenuButton(
          // add icon, by default "3 dot" icon
          // icon: Icon(Icons.book)
          itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: Text("My Account"),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Text("Logout"),
          ),
        ];
      }, onSelected: (value) {
        if (value == 0) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AccountPage()));
        } else if (value == 1) {
          logout();
        }
      })
    ];
  }

  void _startSearch() {
    setState(() {
      _isSearching[pageIndex] = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery[pageIndex] = newQuery;
      searchController[pageIndex].callFilter();
      print(newQuery);
    });
  }

  void _stopSearching() {
    setState(() {
      _isSearching[pageIndex] = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController[pageIndex].clear();
      searchQuery[pageIndex] = "";
    });
    Future.delayed(Duration(milliseconds: 100), () {
      searchController[pageIndex].callFilter();
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Builder(builder: (BuildContext context) {
        tabController = DefaultTabController.of(context);
        return Scaffold(
          appBar: AppBar(
            leading: _isSearching[pageIndex]
                ? BackButton(
                    onPressed: (() {
                      _stopSearching();
                      _clearSearchQuery();
                    }),
                  )
                : null,
            title: _isSearching[pageIndex]
                ? _buildSearchField()
                : Text("${_listTitle[pageIndex]}"),
            actions: _buildActions(),
            bottom: TabBar(
              onTap: (index) {
                setState(() {
                  pageIndex = index;
                });
              },
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.chat),
                ),
                Tab(
                  icon: Icon(Icons.people),
                ),
                Tab(
                  icon: Icon(Icons.category),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              KeepAlivePage(alive: true, child: ChatHistoryElement()),
              KeepAlivePage(
                  alive: !_isSearching[pageIndex],
                  child: CharacterListElement(
                      search: searchQuery[1], controller: searchController[1])),
              KeepAlivePage(
                  alive: !_isSearching[pageIndex],
                  child: CategoryElement(
                      search: searchQuery[2],
                      controller: searchController[2],
                      onTapItem: (v) {
                        if (tabController != null) {
                          tabController!.animateTo(1);
                          setState(() {
                            pageIndex = 1;

                            _isSearching[pageIndex] = true;
                            _searchQueryController[pageIndex].text = v;
                          });
                          Future.delayed(Duration.zero, () {
                            updateSearchQuery(v);
                          });
                        }
                      })),
            ],
          ),
        );
      }),
    );
  }
}
