import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ratatouilleadmin/app/globals.dart';

import '../../controllers/home_controller.dart';
import '../../data/models/user_model.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final HomeController _controller = HomeController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> roles = [
    'Addetti alla sala',
    'Addetti alla cucina',
    'Supervisori'
  ];
  final selectedRoleNotifier = ValueNotifier<String>('Addetti alla sala');
  List<User> users = [];
  List<User> selectedUsers = [];

  @override
  initState() {
    super.initState();
    getUsers();
    selectedRoleNotifier.addListener(() {
      setState(() {
        if (selectedRoleNotifier.value == 'Addetti alla sala') {
          selectedUsers =
              users.where((element) => element.role == 'waiter').toList();
        } else if (selectedRoleNotifier.value == 'Addetti alla cucina') {
          selectedUsers =
              users.where((element) => element.role == 'kitchen').toList();
        } else if (selectedRoleNotifier.value == 'Supervisori') {
          selectedUsers =
              users.where((element) => element.role == 'supervisor').toList();
        }
      });
    });
  }

  getUsers() async {
    users = await _controller.getUsers();
    setState(() {
      selectedUsers =
          users.where((element) => element.role == 'waiter').toList();
    });
  }

  _showConfirmDeleteDialog(BuildContext context, User user) {
    //show dialog for confirm delete category
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Elimina utente'),
          elevation: 24,
          content: const Text('Sei sicuro di voler eliminare questo utente?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () async {
                if (await _controller.deleteUser(user.id)) {
                  scaffoldMessengerKey.currentState!
                      .showSnackBar(const SnackBar(
                          content: Text(
                    'Utente eliminato!',
                    style: TextStyle(color: Colors.white),
                  )));
                  setState(() {
                    Navigator.pop(context);
                    selectedRoleNotifier.value = 'Addetti alla sala';
                    getUsers();
                  });
                }
              },
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );
  }

  _showChangePasswordDialog(BuildContext context, User user) {
    String password = '';
    String confirmpassword = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Cambia password'),
          elevation: 24,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                obscuringCharacter: '*',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                obscuringCharacter: '*',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Conferma password',
                ),
                onChanged: (value) {
                  confirmpassword = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () async {
                if (password.isEmpty || confirmpassword.isEmpty) {
                  scaffoldMessengerKey.currentState!
                      .showSnackBar(const SnackBar(
                          content: Text(
                    'Inserisci la password!',
                    style: TextStyle(color: Colors.white),
                  )));
                  return;
                } else {
                  if (password != confirmpassword) {
                    scaffoldMessengerKey.currentState!
                        .showSnackBar(const SnackBar(
                            content: Text(
                      'Le password non coincidono!',
                      style: TextStyle(color: Colors.white),
                    )));
                    return;
                  } else {
                    if (await _controller.changeUserPassword(
                        user.id, password, true)) {
                      scaffoldMessengerKey.currentState!
                          .showSnackBar(const SnackBar(
                              content: Text(
                        'Password cambiata!',
                        style: TextStyle(color: Colors.white),
                      )));
                      setState(() {
                        Navigator.pop(context);
                      });
                    }
                  }
                }
              },
              child: const Text('Cambia'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 32),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: SvgPicture.asset('images/home.svg'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/menu',arguments: false);
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: SvgPicture.asset(
                            'images/users.svg',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            // Navigator.pushNamed(context, '/cart');
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: SvgPicture.asset('images/stats.svg'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/statistics');
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: SvgPicture.asset('images/profile.svg'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/profile',arguments: false);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //search bar with a text field
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, top: 50),
                child: Card(
                  elevation: 10,
                  color: Theme.of(context).colorScheme.secondary,
                  //rounded corners
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      _controller.searchText = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Cerca',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: SvgPicture.asset(
                          'images/search.svg',
                        ),
                      ),
                      //focus color
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _controller.searchTextNotifier,
                builder: (BuildContext context, String value, Widget? child) {
                  if (value.isEmpty) {
                    return menu();
                  } else {
                    selectedUsers = users
                        .where((element) => element.name
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                    if (selectedUsers.isEmpty) {
                      return Column(children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Nessun risultato',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Prova a cercare qualcos\'altro',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Icon(
                              Icons.sentiment_dissatisfied_rounded,
                              color: Theme.of(context).colorScheme.onBackground,
                              size: 80,
                              grade: 0.5,
                            ),
                          ],
                        ),
                      ]);
                    } else {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              child: SizedBox(
                                height: 320,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: selectedUsers.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      key: Key(selectedUsers[index].id),
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: Dismissible(
                                        key: UniqueKey(),
                                        background: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: SvgPicture.asset(
                                            'images/trash.svg',
                                          ),
                                        ),
                                        direction: DismissDirection.up,
                                        onDismissed: (direction) {
                                          _showConfirmDeleteDialog(
                                              context, selectedUsers[index]);
                                        },
                                        child: SizedBox(
                                          key: Key(selectedUsers[index].id),
                                          height: 300,
                                          child: Card(
                                            key: Key(selectedUsers[index].id),
                                            elevation: 10,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            //rounded corners
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            child: SizedBox(
                                              key: Key(selectedUsers[index].id),
                                              width: 400,
                                              child: Padding(
                                                key: Key(
                                                    selectedUsers[index].id),
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Center(
                                                  key: Key(
                                                      selectedUsers[index].id),
                                                  child: Column(
                                                    key: Key(
                                                        selectedUsers[index]
                                                            .id),
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        '${selectedUsers[index].name} ${selectedUsers[index].surname}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                            fontSize: 22),
                                                      ),
                                                      const SizedBox(
                                                        height: 50,
                                                      ),
                                                      Text(
                                                        selectedUsers[index]
                                                            .email,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                            fontSize: 16),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '*********************',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                                fontSize: 16),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .mode_edit_outline_outlined,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ));
  }

  Widget menu() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ValueListenableBuilder(
            valueListenable: selectedRoleNotifier,
            builder: (BuildContext context, value, Widget? child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 180),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: roles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 50, top: 50),
                          child: TextButton(
                            onPressed: () {
                              selectedRoleNotifier.value = roles[index];
                            },
                            child: Text(
                              roles[index],
                              style: value == roles[index]
                                  ? TextStyle(
                                      shadows: [
                                        Shadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            offset: const Offset(0, -8))
                                      ],
                                      color: Colors.transparent,
                                      fontSize: 20,
                                      decorationThickness: 3,
                                      //padding between text and line
                                      decorationColor:
                                          Theme.of(context).colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'Actor',
                                    )
                                  : TextStyle(
                                      shadows: [
                                        Shadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            offset: const Offset(0, -8))
                                      ],
                                      color: Colors.transparent,
                                      fontSize: 20,
                                      fontFamily: 'Actor',
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    right: 50,
                    top: 50,
                    child: TextButton(
                      onPressed: () {
                        myAppNavigatorKey.currentState!
                            .pushNamed('/adduser');
                      },
                      child: SizedBox(
                        height: 30,
                        child: SvgPicture.asset(
                          'images/add.svg',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        if (selectedUsers.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                'Nessun risultato',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Non ci sono utenti con questo ruolo',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Icon(
                Icons.sentiment_dissatisfied_rounded,
                color: Theme.of(context).colorScheme.onBackground,
                size: 80,
                grade: 0.5,
              ),
            ],
          ),
        if (selectedUsers.isNotEmpty)
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: SizedBox(
                height: 320,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      key: Key(selectedUsers[index].id),
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Dismissible(
                        key: UniqueKey(),
                        background: Align(
                          alignment: Alignment.bottomCenter,
                          child: SvgPicture.asset(
                            'images/trash.svg',
                          ),
                        ),
                        direction: DismissDirection.up,
                        onDismissed: (direction) {
                          _showConfirmDeleteDialog(context, selectedUsers[index]);
                        },
                        child: SizedBox(
                          key: Key(selectedUsers[index].id),
                          height: 300,
                          child: Card(
                            key: Key(selectedUsers[index].id),
                            elevation: 10,
                            color: Theme.of(context).colorScheme.surface,
                            //rounded corners
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: SizedBox(
                              key: Key(selectedUsers[index].id),
                              width: 400,
                              child: Padding(
                                key: Key(selectedUsers[index].id),
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  key: Key(selectedUsers[index].id),
                                  child: Column(
                                    key: Key(selectedUsers[index].id),
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        '${selectedUsers[index].name} ${selectedUsers[index].surname}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 22),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        selectedUsers[index].email,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _showChangePasswordDialog(context, selectedUsers[index]);
                                            },
                                            icon: SvgPicture.asset(
                                              'images/edit.svg',
                                            ),
                                          ),
                                          Text(
                                            '*********************',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
