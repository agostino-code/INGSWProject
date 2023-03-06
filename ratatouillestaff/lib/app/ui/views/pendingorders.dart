import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ratatouillestaff/app/controllers/home_controller.dart';

class PendingOrders extends StatefulWidget {
  const PendingOrders({Key? key}) : super(key: key);

  @override
  State<PendingOrders> createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {});
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(Icons.refresh_outlined, color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
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
                    padding: const EdgeInsets.only(right: 30),
                    child: Text('Ordini',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 20),
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
                Text('swipe a sinistra per annulare l\'ordine',
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onBackground)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder(
                future: controller.getOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //if snapshot data contain an order with status pending
                    if (snapshot.data!
                        .any((element) => element.status == 'pending')) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data![index].status == 'pending') {
                            return Column(
                              children: [
                                Dismissible(
                                  key: UniqueKey(),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: SvgPicture.asset(
                                          'images/trash.svg',
                                        ),
                                      ),
                                    ),
                                  ),
                                  onDismissed: (direction) async {
                                    if (await controller.deleteOrder(
                                        snapshot.data![index].id)) {
                                      setState(() {
                                        snapshot.data!.removeAt(index);
                                      });
                                    }
                                  },
                                  child: Card(
                                    elevation: 10,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            trailing: Column(
                                              children: [
                                                Text(
                                                    DateFormat('HH:mm').format(
                                                        snapshot.data![index]
                                                            .createdAt),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 18,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface)),
                                                Text(
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(snapshot
                                                            .data![index]
                                                            .createdAt),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 10,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface)),
                                              ],
                                            ),
                                            title: Text('Ordine n.$index',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface)),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 10),
                                              child: Text(
                                                  'Tavolo ${snapshot.data![index].table.toString()}',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 15,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface)),
                                            ),
                                          ),
                                          ExpansionTile(
                                            //arrow icon on the center of the tile
                                            title: Text('Dettagli',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary)),
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: snapshot
                                                    .data![index].items.length,
                                                itemBuilder: (context, index2) {
                                                  snapshot.data![index].items
                                                      .sort((a, b) => a
                                                          .item.category.name
                                                          .compareTo(b.item
                                                              .category.name));
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      children: [
                                                        if (index2 == 0 ||
                                                            snapshot
                                                                    .data![
                                                                        index]
                                                                    .items[
                                                                        index2]
                                                                    .item
                                                                    .category
                                                                    .name !=
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .items[
                                                                        index2 -
                                                                            1]
                                                                    .item
                                                                    .category
                                                                    .name)
                                                          Column(
                                                            children: [
                                                              Text(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .items[
                                                                          index2]
                                                                      .item
                                                                      .category
                                                                      .name,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .onSurface)),
                                                              Divider(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                thickness: 2,
                                                              ),
                                                            ],
                                                          ),

                                                        const SizedBox(
                                                            height: 10),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .items[
                                                                        index2]
                                                                    .item
                                                                    .name,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        16,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onSurface)),
                                                            const SizedBox(
                                                                width: 10),
                                                            Card(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25.0),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            25,
                                                                        right:
                                                                            25,
                                                                        top: 2,
                                                                        bottom:
                                                                            2),
                                                                child: Text(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .items[
                                                                            index2]
                                                                        .quantity
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        fontSize:
                                                                            14,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .onPrimary)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        // if(index2==snapshot.data![index].items.length-1 || snapshot.data![index].items[index2].item.category.name != snapshot.data![index].items[index2+1].item.category.name)
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              SizedBox(
                                                width: double.infinity,
                                                height: 40,
                                                child: FloatingActionButton
                                                    .extended(
                                                  onPressed: () async {
                                                    // setState(() {
                                                    if (await controller
                                                        .updateOrder(snapshot
                                                            .data![index].id)) {
                                                      setState(() {
                                                        snapshot.data!
                                                            .removeAt(index);
                                                      });
                                                    }
                                                    // });
                                                  },
                                                  label: Text(
                                                    'Ordine Completato',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                        fontSize: 15,
                                                        fontFamily: 'Actor'),
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'images/nopendingorder.svg',
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Nessun ordine in attesa',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground),
                          ),
                          const SizedBox(height: 10),
                          Text(
                              'Qui saranno presenti gli ordini '
                              'che sono ancora in attesa.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                        ],
                      );
                    }
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
