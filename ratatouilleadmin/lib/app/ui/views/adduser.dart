import 'package:flutter/material.dart';
import 'package:ratatouilleadmin/app/controllers/home_controller.dart';
import 'package:ratatouilleadmin/app/globals.dart';

class AddUserView extends StatefulWidget {
  const AddUserView({super.key});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  final HomeController _controller = HomeController();
  String name = '';
  String surname = '';
  String email = '';
  String password = '';
  String? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text('Aggiungi Personale',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 26,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 600,
              height: MediaQuery.of(context).size.height - 150,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    onChanged: (value) {
                      surname = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Cognome',
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password temporanea',
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ruolo',
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    value: role,
                    onChanged: (value) {
                      setState(() {
                        role = value;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'waiter',
                        child: Text('Addetto alla sala'),
                      ),
                      DropdownMenuItem(
                        value: 'kitchen',
                        child: Text('Addetto alla cucina'),
                      ),
                      DropdownMenuItem(
                        value: 'supervisor',
                        child: Text('Supervisore'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 600,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  //padding for the text
                  //rounded corners
                  onPressed: () async {
                      if (await _controller.userSignUp(
                          name, surname, email, password, role!)) {
                        myAppNavigatorKey.currentState!.pushNamedAndRemoveUntil(
                            '/users', (Route<dynamic> route) => false);
                        scaffoldMessengerKey.currentState!.showSnackBar(
                          const SnackBar(
                            content: Text('Utente aggiunto!',
                                style: TextStyle(color: Colors.white)),
                          ),
                        );
                    }
                  },
                  child: Text('Salva',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
