import 'package:flutter/material.dart';
import 'package:ratatouillestaff/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                    color: Theme.of(context).cardColor,
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
                                  style: TextStyle(
                                      fontSize: 15, fontFamily: 'Actor'),
                                ),
                              ),
                              SizedBox(
                                width: 400,
                                height: 3,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  // elevation: 10,
                                  margin: const EdgeInsets.all(0),
                                  color: Theme.of(context).primaryColor,
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
                  const TextField(
                    decoration: InputDecoration(
                     labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Actor',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const TextField(
                    obscureText: true,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Actor',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: null,
                    child: Align(
                      child: Text(
                      'Password dimenticata?',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Actor',
                        color: Theme.of(context).primaryColor,
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
                  onPressed: () {
                  },
                  label: const Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Actor'),
                  ),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Theme.of(context).primaryColor,
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