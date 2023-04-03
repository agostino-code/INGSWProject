import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ratatouilleadmin/app/controllers/home_controller.dart';
import 'package:ratatouilleadmin/app/globals.dart';

class RestaurantsView extends StatelessWidget {
  final HomeController _controller = HomeController();

  _showdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Aggiungi un ristorante'),
          elevation: 24,
          content: const TextField(
            decoration: InputDecoration(
              hintText: 'Nome del ristorante',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  RestaurantsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const SizedBox(width: 24),
                Expanded(
                  child: Text('I tuoi ristoranti',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26,
                          color: Theme.of(context).colorScheme.onBackground)),
                ),
                IconButton(
                  onPressed: () {
                    _showdialog(context);
                  },
                  icon: SvgPicture.asset(
                    'images/add.svg',
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _controller.getRestaurants(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: Container(
                              width: 600,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  _controller
                                      .setRestaurant(snapshot.data![index]);
                                  myAppNavigatorKey.currentState!
                                      .pushNamed('/menu',arguments: false);
                                },
                                child: Text(snapshot.data![index].name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface)),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
