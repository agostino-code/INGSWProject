import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../controllers/home_controller.dart';
import '../../data/models/restaurant_model.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.supervisor}) : super(key: key);

  final bool supervisor;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final HomeController _controller = HomeController();
  late Restaurant _restaurant;

  @override
  initState() {
    super.initState();
    getRestaurant();
  }

  getRestaurant() async {
    _restaurant = await _controller.getRestaurant();
    setState(() {});
  }


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
              padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
              child: Column(
                children: [
                  Row(
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
                              Navigator.pushNamed(context, '/menu',
                                  arguments: widget.supervisor);
                            },
                          ),
                          if(!widget.supervisor)
                          const SizedBox(
                            width: 30,
                          ),
                          if(!widget.supervisor)
                          IconButton(
                            icon: SvgPicture.asset('images/users.svg'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/users');
                            },
                          ),
                          if(!widget.supervisor)
                          const SizedBox(
                            width: 30,
                          ),
                          if(!widget.supervisor)
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
                            icon: SvgPicture.asset('images/profile.svg',color: Theme.of(context).colorScheme.primary,),
                            onPressed: () {
                            },
                          ),
                        ],
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
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      color: Theme.of(context).colorScheme.surface,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                      child: FutureBuilder(
                        future: _controller.getUser(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
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
                                  Text(_restaurant.name,
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
                                      snapshot.data!.role == 'supervisor'
                                          ? 'Supervisore'
                                          : 'Admin',
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
                                'Sei sicuro di voler uscire?',style: TextStyle(color: Colors.white),),
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
          ),
        ],
      ),
    ),
    );
}
}
