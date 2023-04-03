import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../controllers/home_controller.dart';
import '../../data/models/category_model.dart';
import '../../globals.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key, required this.supervisor});

  final bool supervisor;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final HomeController _controller = HomeController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Categories>? categories;

  @override
  initState() {
    super.initState();
    getCategories();
  }

  getCategories() async {
    categories = await _controller.getCategories();
    setState(() {});
  }

  _showdialognew(BuildContext context) {
    String? name;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Aggiungi una categoria'),
          elevation: 24,
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Nome della categoria',
            ),
            onChanged: (value) {
              name = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () async {
                if (name != null) {
                  if (name!.trim().isEmpty) {
                    scaffoldMessengerKey.currentState!
                        .showSnackBar(const SnackBar(
                            content: Text(
                      'Inserisci un nome valido!',
                      style: TextStyle(color: Colors.white),
                    )));
                  } else {
                    if (await _controller.newCategory(name!)) {
                      scaffoldMessengerKey.currentState!
                          .showSnackBar(const SnackBar(
                              content: Text(
                        'Categoria aggiunta!',
                        style: TextStyle(color: Colors.white),
                      )));
                      setState(() {
                        getCategories();
                        Navigator.pop(context);
                      });
                    }
                  }
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  _showdialog(BuildContext context, Categories category) {
    //show dialog for confirm delete category
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Elimina categoria'),
          elevation: 24,
          content:
              const Text('Sei sicuro di voler eliminare questa categoria?'),
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
                setState(() {
                  categories!.remove(category);
                  Navigator.pop(context);
                });
                if (await _controller.deleteCategory(category.id)) {
                  scaffoldMessengerKey.currentState!
                      .showSnackBar(const SnackBar(
                          content: Text(
                    'Categoria eliminata!',
                    style: TextStyle(color: Colors.white),
                  )));
                }
              },
              child: const Text('Elimina'),
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
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    myAppNavigatorKey.currentState!
                        .pushReplacementNamed('/menu',arguments: widget.supervisor);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Expanded(
                  child: Text('Categorie',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26,
                          color: Theme.of(context).colorScheme.onBackground)),
                ),
                IconButton(
                  onPressed: () {
                    _showdialognew(context);
                  },
                  icon: SvgPicture.asset(
                    'images/add.svg',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: SvgPicture.asset(
                    'images/swipe.svg',
                  ),
                ),
                Text('swipe a sinistra per annulare eliminare la categoria',
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onBackground)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (categories != null)
              Expanded(
                child: ReorderableListView.builder(
                  onReorder: (oldIndex, newIndex) async {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    setState(() {
                      final Categories item = categories!.removeAt(oldIndex);
                      categories!.insert(newIndex, item);
                    });
                    await _controller.categoryChangeIndex(
                        categories![newIndex].id, newIndex);
                  },
                  itemCount: categories!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      key: Key(categories![index].id),
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        key: Key(categories![index].id),
                        child: Dismissible(
                          direction: DismissDirection.endToStart,
                          key: UniqueKey(),
                          background: Align(
                            key: Key(categories![index].id),
                            alignment: Alignment.centerRight,
                            child: SvgPicture.asset(
                              'images/trash.svg',
                            ),
                          ),
                          onDismissed: (direction) {
                            _showdialog(context, categories![index]);
                            // _controller.deleteCategory(
                            //     snapshot.data![index].id);
                          },
                          child: Container(
                            key: Key(categories![index].id),
                            width: 600,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextButton(
                              key: Key(categories![index].id),
                              //padding for the text
                              //rounded corners
                              onPressed: () {
                                myAppNavigatorKey.currentState!.pushNamed(
                                    '/items',
                                    arguments: categories![index]);
                              },
                              child: Text(
                                  key: Key(categories![index].id),
                                  categories![index].name,
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
                      ),
                    );
                  },
                ),
              ),
            if (categories == null)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
