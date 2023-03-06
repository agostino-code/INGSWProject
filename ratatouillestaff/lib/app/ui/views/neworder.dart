import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/home_controller.dart';

class NewOrderView extends StatefulWidget {
  const NewOrderView({Key? key, required this.controller}) : super(key: key);

  final HomeController controller;

  @override
  State<StatefulWidget> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrderView> {
  get controller => widget.controller;

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
                      padding: const EdgeInsets.only(right: 25),
                      child: Text('Nuovo Ordine',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color:
                                  Theme.of(context).colorScheme.onBackground)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
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
                  Text('swipe a sinistra per eliminare',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onBackground)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: controller.orderItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Theme.of(context).colorScheme.background,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: SvgPicture.asset(
                                    'images/trash.svg',
                                  ),
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              controller.orderLenght = controller.orderLenght -
                                  controller.orderItems[index].quantity;
                              controller.orderItems.removeAt(index);
                            },
                            child: Card(
                              elevation: 10,
                              color: Theme.of(context).colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(30),
                                height: 120,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        controller.orderItems[index].item.name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '€${controller.orderItems[index].item.price.toString()}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          height: 30,
                                          width: 100,
                                          child: ValueListenableBuilder(
                                            valueListenable: controller
                                                .orderItems[index]
                                                .quantityNotifier,
                                            builder: (context, value, child) {
                                              if (value == 0) {
                                                controller.orderItems
                                                    .removeAt(index);
                                              }
                                              return Row(
                                                children: [
                                                  IconButton(
                                                    iconSize: 20,
                                                    onPressed: () {
                                                      controller
                                                          .orderItems[index]
                                                          .quantity--;
                                                      controller.orderLenght--;
                                                      setState(() {
                                                        if (controller
                                                                .orderItems[
                                                                    index]
                                                                .quantity ==
                                                            0) {
                                                          controller.orderItems
                                                              .removeAt(index);
                                                        }
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.remove),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      controller
                                                          .orderItems[index]
                                                          .quantity
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    iconSize: 20,
                                                    onPressed: () {
                                                      controller.orderLenght++;
                                                      controller
                                                          .orderItems[index]
                                                          .quantity++;
                                                    },
                                                    icon: const Icon(Icons.add),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  controller.table = int.parse(value);
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Numero del tavolo',
                  labelStyle: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onBackground),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 600,
                height: 60,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    controller.newOrder();
                  },
                  label: Text(
                    'Invia ordine',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontFamily: 'Actor'),
                  ),
                  elevation: 10,
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
