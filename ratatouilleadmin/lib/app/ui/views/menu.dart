import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';
import 'package:qr/qr.dart';
import 'package:ratatouilleadmin/app/data/models/item_model.dart';
import 'package:ratatouilleadmin/app/globals.dart';

import '../../controllers/home_controller.dart';
import '../../data/models/category_model.dart';
import '../../data/models/restaurant_model.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key, required this.supervisor});

  final bool supervisor;

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final HomeController _controller = HomeController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Item>? items;
  List<Categories> categories = [];

  @override
  initState() {
    super.initState();
    getCategories();
    _controller.selectedCategoryNotifier.addListener(() {
      getItems();
    });
  }

  getItems() async {
    items =
        await _controller.getSelectedItems(_controller.selectedCategory!.id);
    setState(() {});
  }

  getCategories() async {
    categories = await _controller.getCategories();
    _controller.selectedCategory = categories[0];
  }

  _showConfirmDeleteDialog(BuildContext context, Item item) {
    //show dialog for confirm delete category
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Elimina item'),
          elevation: 24,
          content: const Text('Sei sicuro di voler eliminare questo item?'),
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
                items!.remove(item);
                if (await _controller.deleteItem(item.id)) {
                  scaffoldMessengerKey.currentState!
                      .showSnackBar(const SnackBar(
                          content: Text(
                    'Item eliminato!',
                    style: TextStyle(color: Colors.white),
                  )));
                  setState(() {
                    Navigator.pop(context);
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

  _showGenerateQrCodeDialog(BuildContext context) {
    Language selectedLanguage = Languages.english;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Genera QR Code'),
          elevation: 24,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Seleziona la lingua per il tuo menu'),
              LanguagePickerDropdown(
                initialValue: Languages.english,
                onValuePicked: (Language language) {
                  selectedLanguage = language;
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
                showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                Restaurant restaurant = await _controller.getRestaurant();
                if (selectedLanguage.isoCode != 'it') {
                  if (await _controller
                      .generateMenu(selectedLanguage.isoCode)) {
                    setState(() {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      _showGeneratedQrCodeDialog(
                          context, restaurant, selectedLanguage);
                    });
                  }
                } else {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    _showGeneratedQrCodeDialog(
                        context, restaurant, selectedLanguage);
                  });
                }
              },
              child: const Text('Genera'),
            ),
          ],
        );
      },
    );
  }

  _showGeneratedQrCodeDialog(
      BuildContext context, Restaurant restaurant, Language language) {
    var qr = QrCode(4, QrErrorCorrectLevel.M);
    var url = _controller.menuUrl(language.isoCode, restaurant.id);
    qr.addData(url);
    qr.make();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          //rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 24,
          child: Container(
            width: 370,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.onBackground,
            ),
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: qr.moduleCount,
              itemBuilder: (context, i) {
                return Row(
                  children: List.generate(
                    qr.moduleCount,
                    (index) => Container(
                      width: 10,
                      height: 10,
                      color: qr.isDark(i, index)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
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
                        icon: SvgPicture.asset('images/home.svg',
                            color: Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          // Navigator.pushNamed(context, '/home');
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
                        icon: SvgPicture.asset('images/profile.svg'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/profile',
                              arguments: widget.supervisor);
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
                  return Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      FutureBuilder<List<Item>>(
                        future: _controller.searchItems(value.trim()),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Nessun risultato',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontSize: 20,
                                    ),
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
                                      fontSize: 15,
                                    ),
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
                                        child: Dismissible(
                                          key: UniqueKey(),
                                          direction: DismissDirection.up,
                                          background: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: SvgPicture.asset(
                                              'images/trash.svg',
                                            ),
                                          ),
                                          onDismissed: (direction) {
                                            _showConfirmDeleteDialog(
                                                context, snapshot.data[index]);
                                          },
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
                                                    width: 400,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
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
                                            ],
                                          ),
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
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 180),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 50, top: 50),
                          child: TextButton(
                            onPressed: () {
                              _controller
                                  .setSelectedCategory(categories[index]);
                            },
                            child: Text(
                              categories[index].name,
                              style: value?.name == categories[index].name
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
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            myAppNavigatorKey.currentState!
                                .pushNamed('/categories',arguments: widget.supervisor);
                          },
                          child: SizedBox(
                            height: 30,
                            child: SvgPicture.asset(
                              'images/add.svg',
                            ),
                          ),
                        ),
                        if(!widget.supervisor)
                        const SizedBox(
                          width: 10,
                        ),
                        if(!widget.supervisor)
                        TextButton(
                          onPressed: () {
                            _showGenerateQrCodeDialog(context);
                          },
                          child: SizedBox(
                            height: 30,
                            child: SvgPicture.asset(
                              'images/qr.svg',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        if (items == null)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (items != null)
          if (items!.isEmpty)
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
                  'Non ci sono piatti in questa categoria',
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
        if (items != null)
          if (items!.isNotEmpty)
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: SizedBox(
                  height: 330,
                  child: ReorderableListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        key: Key(items![index].id),
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
                            _showConfirmDeleteDialog(context, items![index]);
                          },
                          child: SizedBox(
                            key: Key(items![index].id),
                            height: 300,
                            child: Card(
                              key: Key(items![index].id),
                              elevation: 10,
                              color: Theme.of(context).colorScheme.surface,
                              //rounded corners
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: SizedBox(
                                key: Key(items![index].id),
                                width: 400,
                                child: Padding(
                                  key: Key(items![index].id),
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    key: Key(items![index].id),
                                    child: Column(
                                      key: Key(items![index].id),
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          items![index].name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontSize: 22),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            items![index].description,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: (items![index]
                                                        .allergens
                                                        .toString() ==
                                                    '[]')
                                                ? const SizedBox(
                                                    height: 15,
                                                  )
                                                : Text(
                                                    'Allergeni: ${items![index].allergens.toString().replaceAll('[', '').replaceAll(']', '')}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onError,
                                                        fontSize: 16),
                                                  )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            '€${items![index].price.toString()}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Theme.of(context)
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
                        ),
                      );
                    },
                    onReorder: (int oldIndex, int newIndex) async {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      setState(() {
                        final Item item = items!.removeAt(oldIndex);
                        items!.insert(newIndex, item);
                      });
                      await _controller.itemChangeIndex(
                          items![newIndex].id, newIndex);
                    },
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
