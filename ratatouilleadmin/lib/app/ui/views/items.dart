import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ratatouilleadmin/app/controllers/home_controller.dart';
import 'package:ratatouilleadmin/app/globals.dart';

import '../../data/models/category_model.dart';
import '../../data/models/item_model.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key, required this.currentCategory});

  final Categories currentCategory;

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  final HomeController _controller = HomeController();
  final TextEditingController _allergeneController = TextEditingController();
  final List<String> allergeni = [];
  String name = '';
  String description = '';
  String price = '';

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
                    child: Text('Aggiungi ${widget.currentCategory.name}',
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
                  RawAutocomplete(
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          labelStyle: TextStyle(fontSize: 15),
                        ),
                        onFieldSubmitted: (String value) {
                          onFieldSubmitted();
                        },
                        onChanged: (String value) {
                          name = value;
                        },
                      );
                    },
                    optionsViewBuilder: (BuildContext context,
                        void Function(Object) onSelected,
                        Iterable<Object> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: SizedBox(
                            height: 200,
                            width: 600,
                            child: ListView(
                              padding: const EdgeInsets.all(8.0),
                              children: options.map((Object option) {
                                return GestureDetector(
                                  onTap: () {
                                    onSelected(option);
                                    name= option.toString();
                                  },
                                  child: ListTile(
                                    title: Text(option.toString()),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return await _controller
                          .getSuggestions(textEditingValue.text);
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    onChanged: (value) {
                      price = value;
                    },
                    inputFormatters: [
                      //REG only numbers 0-9 no space
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Costo',
                      //euro after text
                      suffixText: '€',
                      labelStyle: TextStyle(
                        fontSize: 15,

                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: _allergeneController,
                    onSubmitted: (value) {
                      setState(() {
                        allergeni.add(value);
                        _allergeneController.clear();
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Allergeni',
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        if(allergeni.isNotEmpty)
                        for (final allergene in allergeni)
                          Chip(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.onBackground,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            label: Text(allergene),
                            onDeleted: () {
                              setState(() {
                                allergeni.remove(allergene);
                              });
                            },
                          ),
                        if(allergeni.isEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Chip(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),

                              label: const Text('Nessun allergene'),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    onChanged: (value) {
                      description = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Descrizione',
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
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
                    if(name != '' && price != '') {
                      Item item=Item('',name,description,price,allergeni,widget.currentCategory);
                      if(await _controller.newItem(item)){
                        scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
                          content: Text('Item aggiunto!',style: TextStyle(color: Colors.white),),
                        ));
                        myAppNavigatorKey.currentState?.pushReplacementNamed('/menu',arguments: false);
                      }
                    }else{
                      scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
                        content: Text('Inserisci un nome ed un prezzo',style: TextStyle(color: Colors.white),),
                      ));
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
