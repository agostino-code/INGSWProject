import 'package:flutter/material.dart';

import '../../controllers/home_controller.dart';
import '../../data/models/user_model.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Text('Storia',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text('Informazioni',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20,
                              color:
                                  Theme.of(context).colorScheme.onBackground)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 10,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: FutureBuilder(
                            future: _controller.getUser(),
                            builder: (BuildContext context,
                                AsyncSnapshot<User> snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                          '${snapshot.data!.name} ${snapshot.data!.surname}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(snapshot.data!.email,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(snapshot.data!.restaurant.name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          snapshot.data!.role == 'waiter'
                                              ? 'Addetto alla sala'
                                              : 'Addetto alla cucina',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                    ],
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/changepassword',
                              arguments: false);
                        },
                        child: Text(
                          'Modifica password!',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 600,
                        height: 60,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            //Confirm sign-out
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Sei sicuro di voler uscire?'),
                                action: SnackBarAction(
                                  label: 'Sì',
                                  textColor: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                  onPressed: () {
                                    _controller.signOut();
                                  },
                                ),
                              ),
                            );
                          },
                          label: Text(
                            'Sign-out',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 18,
                                fontFamily: 'Actor'),
                          ),
                          elevation: 10,
                          clipBehavior: Clip.antiAlias,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
