import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SendendOrder extends StatelessWidget {
  const SendendOrder({Key? key, this.table}) : super(key: key);

  final int? table;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Ordine Inviato',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  height: 10,
                ),
                SvgPicture.asset(
                  'images/sendendorder.svg',
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    'L’ordine per il tavolo numero $table è'
                    ' stato inoltrato alla cucina.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onBackground))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
