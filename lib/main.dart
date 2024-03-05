import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdvanceTech',
      theme: ThemeData(
        primarySwatch: white,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'AdvanceTech'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 50,
                child: Icon(
                  CupertinoIcons.rocket,
                  size: 40,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  "AdvanceTech",
                  style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    color: Color(0xC6000000),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: MediaQuery.of(context).size.width > 600
              ? [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            email: 'milanpreetkaur502@gmail.com',
                          ),
                        ),
                      );
                    },
                    icon: Icon(CupertinoIcons.macwindow, size: 25),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.globe, size: 25),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.location_solid,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.gear,
                      size: 25,
                    ),
                  ),
                ]
              : [
                  IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(Icons.menu),
                  )
                ],
        ),
        drawer: MediaQuery.of(context).size.width > 600
            ? null
            : Drawer(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(CupertinoIcons.macwindow, size: 25),
                      title: Text('Dashboard'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              email: 'milanpreetkaur502@gmail.com',
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.globe, size: 25),
                      title: Text('Countries'),
                      onTap: () {
                        // Implement action
                      },
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.location_solid, size: 25),
                      title: Text('Location'),
                      onTap: () {
                        // Implement action
                      },
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.gear, size: 25),
                      title: Text('Settings'),
                      onTap: () {
                        // Implement action
                      },
                    ),
                  ],
                ),
              ),
        body: Container(
          padding: EdgeInsets.all(100.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/team-pana.png"),
              fit: BoxFit.contain,
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
