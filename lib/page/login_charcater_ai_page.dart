import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginCharacterAiPage extends StatefulWidget {
  const LoginCharacterAiPage({super.key});

  @override
  State<LoginCharacterAiPage> createState() => _LoginCharacterAiPageState();
}

class _LoginCharacterAiPageState extends State<LoginCharacterAiPage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      javaScriptEnabled: true,
      domStorageEnabled: true,
      clearCache: true,
      clearSessionCache: true,
      iframeAllowFullscreen: true);

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  bool loginPage = false;
  bool loginSubmit = false;
  bool checkToken = false;

  void initWebview() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  void saveToken(String token, BuildContext context) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "char_token", value: token);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initWebview();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  //https://beta.character.ai/login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login to Character.ai")),
        body: SafeArea(
            child: Column(children: <Widget>[
          Text("url: $url"),
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(
                      url: WebUri("https://beta.character.ai/login")),
                  initialSettings: settings,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) async {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                    });
                  },
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(
                        resources: request.resources,
                        action: PermissionResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunchUrl(uri)) {
                        // Launch the App
                        await launchUrl(
                          uri,
                        );
                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController?.endRefreshing();
                    setState(() {
                      this.url = url.toString();
                    });

                    //get domain name
                    var domain = Uri.parse(url.toString()).host;

                    if (domain == "character-ai.us.auth0.com" && !loginPage) {
                      loginPage = true;
                    }

                    if (domain == "beta.character.ai" &&
                        loginPage &&
                        !loginSubmit) {
                      loginSubmit = true;
                    }

                    if (domain == "beta.character.ai" &&
                        loginPage &&
                        loginSubmit &&
                        !checkToken) {
                      checkToken = true;
                      Timer.periodic(new Duration(seconds: 3), (timer) {
                        try {
                          print("check token");
                          controller.webStorage.localStorage
                              .getItem(key: "char_token")
                              .then((value) {
                            if (value != null) {
                              timer.cancel();
                              print("get token");
                              print(value["value"]);

                              saveToken(value["value"], context);
                              Navigator.pop(context);
                            }
                          }).catchError((e) {
                            print(e);
                            timer.cancel();
                          });
                        } catch (_) {
                          timer.cancel();
                        }
                      });
                    }

                    controller.webStorage.localStorage
                        .getItem(key: "in_eu")
                        .then((value) {
                      print(value);
                      print("test 1");
                    });

                    controller.webStorage.localStorage
                        .getItem(key: "chat_onboarding")
                        .then((value) {
                      print(value);
                      print("test 2");
                    });

                    controller.webStorage.localStorage
                        .getItem(key: "uuid")
                        .then((value) {
                      print(value);
                      print("test 3");
                    });
                  },
                  onReceivedError: (controller, request, error) {
                    pullToRefreshController?.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController?.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Icon(Icons.refresh),
                onPressed: () {
                  webViewController?.reload();
                },
              ),
            ],
          ),
        ])));
  }
}
