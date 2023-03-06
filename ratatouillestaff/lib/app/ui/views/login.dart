import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ratatouillestaff/app/controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController _controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: ListView(
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        shrinkWrap: true,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 300,
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                margin: const EdgeInsets.all(0),
                color: Theme.of(context).colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(50),
                      child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/logo.png'))),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            height: 3,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              // elevation: 10,
                              margin: const EdgeInsets.all(0),
                              color: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            //Text Field Email and Password
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      _controller.setEmail(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    onChanged: (value) {
                      _controller.setPassword(value);
                    },
                    obscureText: true,
                    obscuringCharacter: '*',
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contatta l''amministratore del ristorante!' ),
                        ),
                      );
                    },
                    child: Align(
                      child: Text(
                        'Password dimenticata?',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 600,
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    _controller.login();
                  },
                  label: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
