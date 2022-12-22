import 'package:flutter/material.dart';
import 'package:friend_ai/model/user.dart';
import 'package:friend_ai/page/login_charcater_ai_page.dart';
import 'package:friend_ai/provider/storage_provider.dart';
import 'package:friend_ai/repository/user_repository.dart';
import 'package:friend_ai/utility/utility_helper.dart';
import 'package:restart_app/restart_app.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? token;
  User? user;

  void getUser() async {
    UtilityHelper.showAlertDialogLoading(
        context, "Loading...", "Autentikasi user...");
    await StorageProvider.getLocalToken().then((value) async {
      if (value != null) {
        token = value;
        await UserRepository.getUser(value).then((_user) {
          setState(() {
            user = _user;
          });
        });
      }
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    if (user != null) {
      UtilityHelper.showSnackBar(context, "Hello ${user!.username}");
    }
  }

  void logout() async {
    UtilityHelper.showAlertDialogLoading(
        context, "Loading...", "Logout account...");
    await StorageProvider.deleteAll();
    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.of(context).pop();
      Restart.restartApp();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Account"),
        ),
        body: (user != null)
            ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple,
                            ),
                            child: Center(
                              child: Text(
                                "${user!.username![0]}",
                                style: TextStyle(fontSize: 50),
                              ),
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user!.username}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${user!.firstName}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      logout();
                    },
                  ),
                ],
              )
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Guest',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Guest",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.login),
                    title: const Text('Login'),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => LoginCharacterAiPage()))
                          .then((value) {
                        setState(() {});
                      });
                    },
                  ),
                ],
              ));
  }
}
