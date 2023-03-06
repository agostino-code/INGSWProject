import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ratatouillestaff/app/data/models/item_model.dart';

import '../../controllers/home_controller.dart';
import '../../data/models/category_model.dart';
import '../../globals.dart';
import 'package:badges/badges.dart' as badges;

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                iconSize: 25,
                icon: SvgPicture.asset('images/home.svg'),
                onPressed: () {
                  // Navigator.pushNamed(context, '/home');
                },
              ),
              ValueListenableBuilder(
                valueListenable: _controller.orderLenghtNotifier,
                builder: (BuildContext context, value, Widget? child) {
                  return badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      borderRadius: BorderRadius.circular(10),
                      badgeColor: Theme.of(context).colorScheme.primary,
                    ),
                    badgeContent: Text(
                      _controller.orderLenght.toString(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    showBadge: _controller.orderLenght > 0,
                    child: IconButton(
                      iconSize: 25,
                      // color: Colors.grey[600],
                      icon: SvgPicture.asset(
                        'images/neworder.svg',
                      ),
                      onPressed: () {
                        myAppNavigatorKey.currentState!
                            .pushNamed('/neworder', arguments: _controller);
                      },
                    ),
                  );
                },
              ),
              IconButton(
                iconSize: 25,
                icon: SvgPicture.asset('images/allorders.svg'),
                onPressed: () {
                  myAppNavigatorKey.currentState!.pushNamed('/pendingorders');
                },
              ),
              IconButton(
                iconSize: 25,
                icon: SvgPicture.asset(
                  'images/orderstory.svg',
                ),
                onPressed: () {
                  myAppNavigatorKey.currentState!.pushNamed('/orderhistory');
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50,top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 32,
                        fontFamily: 'Actor'),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'images/profile.svg',
                    ),
                    onPressed: () {
                      myAppNavigatorKey.currentState!.pushNamed('/profile');
                    },
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
            //list of categories scrollable
            ValueListenableBuilder(
              valueListenable: _controller.searchTextNotifier,
              builder: (BuildContext context, String value, Widget? child) {
                if (value.isEmpty) {
                  return menu();
                } else {
                  return Column(
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            FutureBuilder<List<Item>>(
                              future: _controller.searchItems(value),
                              builder:
                                  (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  if(snapshot.data!.isEmpty){
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Nessun risultato',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontSize: 20,),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Prova a cercare qualcos\'altro',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontSize: 15,),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Icon(
                                          Icons.sentiment_dissatisfied_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          size: 80,
                                          grade: 0.5,
                                        ),
                                      ],
                                    );
                                  }
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: SizedBox(
                                        height: 320,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 30),
                                              child: Stack(
                                                children: [
                                                  SizedBox(
                                                    height: 300,
                                                    child: Card(
                                                      elevation: 10,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                      //rounded corners
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                30.0),
                                                      ),
                                                      child: SizedBox(
                                                        width: 200,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  20.0),
                                                          child: Center(
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  snapshot
                                                                      .data![index]
                                                                      .name,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .onSurface,
                                                                      fontSize: 22),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          top: 20),
                                                                  child: Text(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .description,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Theme.of(
                                                                                context)
                                                                            .colorScheme
                                                                            .onSurface,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                                .only(
                                                                            top:
                                                                                20),
                                                                    child: (snapshot
                                                                                .data![index]
                                                                                .allergens
                                                                                .toString() ==
                                                                            '[]')
                                                                        ? const SizedBox(
                                                                            height:
                                                                                15,
                                                                          )
                                                                        : Text(
                                                                            'Allergeni: ${snapshot.data![index].allergens.toString().replaceAll('[', '').replaceAll(']', '')}',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                                color:
                                                                                    Theme.of(context).colorScheme.onError,
                                                                                fontSize: 16),
                                                                          )),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          top: 20),
                                                                  child: Text(
                                                                    '€${snapshot.data![index].price.toString()}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Theme.of(
                                                                                context)
                                                                            .colorScheme
                                                                            .primary,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 15,
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: IconButton(
                                                        icon: SvgPicture.asset(
                                                          'images/additem.svg',
                                                        ),
                                                        onPressed: () {
                                                          _controller.orderLenght++;
                                                          _controller
                                                              .addItemToOrder(
                                                                  snapshot.data![
                                                                      index]);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget menu() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ValueListenableBuilder(
            valueListenable: _controller.selectedCategoryNotifier,
            builder: (BuildContext context, value, Widget? child) {
              return FutureBuilder<List<Categories>>(
                future: _controller.getCategories(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 50, top: 50),
                          child: TextButton(
                            onPressed: () {
                              _controller
                                  .setSelectedCategory(snapshot.data[index]);
                            },
                            child: Text(
                              snapshot.data[index].name,
                              style: value?.name == snapshot.data[index].name
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
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _controller.selectedCategoryNotifier,
          builder: (BuildContext context, value, Widget? child) {
            if (value == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return FutureBuilder<List<Item>>(
                future: _controller.getSelectedItems(value.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          height: 320,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 300,
                                      child: Card(
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
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    snapshot.data![index].name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                        fontSize: 22),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: Text(
                                                      snapshot.data![index]
                                                          .description,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: (snapshot
                                                                  .data![index]
                                                                  .allergens
                                                                  .toString() ==
                                                              '[]')
                                                          ? const SizedBox(
                                                              height: 15,
                                                            )
                                                          : Text(
                                                              'Allergeni: ${snapshot.data![index].allergens.toString().replaceAll('[', '').replaceAll(']', '')}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onError,
                                                                  fontSize: 16),
                                                            )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: Text(
                                                      '€${snapshot.data![index].price.toString()}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 15,
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: IconButton(
                                          icon: SvgPicture.asset(
                                            'images/additem.svg',
                                          ),
                                          onPressed: () {
                                            _controller.orderLenght++;
                                            _controller.addItemToOrder(
                                                snapshot.data![index]);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          },
        ),
      ],
    );
  }
}
