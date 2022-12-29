import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ratatouillestaff/routes/app_routes.dart';

class BenvenutoScreen extends StatelessWidget {
  const BenvenutoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      //resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          if (MediaQuery.of(context).orientation == Orientation.portrait)
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/benvenuto.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.55,
              ),
            ),
          if (MediaQuery.of(context).orientation == Orientation.landscape)
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/benvenuto.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 110,
                          height: 130,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 10,
                            margin: const EdgeInsets.only(
                                left: 40, top: 40, bottom: 20),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                  // color: Colors.white,
                                  // borderRadius: BorderRadius.circular(50),
                                  image: DecorationImage(
                                      image: AssetImage('images/logo.png'))),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(left: 40),
                                child: Text(
                                  "Ratatouille\n23",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 55,
                                      fontFamily: 'Actor'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20, left: 40),
                                child: Text(
                                  "Staff",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 55,
                                      fontFamily: 'Actor'),
                                ),
                              ),
                            ]),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 600,
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                Timer(const Duration(milliseconds: 300), () {
                                  Navigator.pushNamed(context, loginScreen);
                                });
                                // Navigator.pushNamed(context, loginScreen);
                              },
                              label: Text(
                                'Inizia',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontFamily: 'Actor'),
                              ),
                              elevation: 10,
                              clipBehavior: Clip.antiAlias,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
