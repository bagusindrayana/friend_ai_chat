import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as inapp;
import 'package:friend_ai/component/keep_page_alive.dart';
import 'package:friend_ai/page/character_list_element.dart';
import 'package:friend_ai/page/chat_history_element.dart';
import 'package:friend_ai/page/login_charcater_ai_page.dart';

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
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  final SearchController searchController = SearchController();

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
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
    if (_isSearching) {
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
    ];
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      searchController.callFilter();
    });
  }

  void _stopSearching() {
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      searchQuery = "";
    });
    Future.delayed(Duration(milliseconds: 100), () {
      searchController.callFilter();
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
      child: Scaffold(
        appBar: AppBar(
          leading: _isSearching
              ? BackButton(
                  onPressed: (() {
                    _stopSearching();
                    _clearSearchQuery();
                  }),
                )
              : null,
          title: _isSearching ? _buildSearchField() : Text('Chat with AI'),
          actions: _buildActions(),
          bottom: const TabBar(
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
            ChatHistoryElement(),
            KeepAlivePage(
                alive: !_isSearching,
                child: CharacterListElement(
                    search: searchQuery, controller: searchController)),
            Center(
              child: Text("Categories"),
            ),
          ],
        ),
      ),
    );
  }
}
