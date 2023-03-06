import 'package:flutter/material.dart';

class BenvenutoView extends StatelessWidget {
  const BenvenutoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
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
                                Navigator.pushNamed(context, '/login');
                              },
                              label: Text(
                                'Inizia',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 18,
                                    fontFamily: 'Actor'),
                              ),
                              elevation: 10,
                              clipBehavior: Clip.antiAlias,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimary,
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
