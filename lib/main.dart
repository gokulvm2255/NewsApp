import 'package:flutter/material.dart';
import 'package:newsapp/bookmark.dart';
import 'package:newsapp/loginpage.dart';
import 'package:newsapp/newsfeed.dart';
import 'package:newsapp/providerhelper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main(){
  runApp(
    ChangeNotifierProvider(create: (context)=>BookmarkProviderHelper(),
   child: MyWidget(),
   ),
   );
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserloggedCheck(),
    );
  }
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    NewsFeed(),
    BookMark(),
    
      ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    
  }
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),

        ),
        bottomNavigationBar:BottomNavigationBar(
          
          
          items:const[
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookmarks'),
          ],
          currentIndex: _selectedIndex,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          
          
          onTap: _onItemTapped,
         ),
      ),
    );
  }
}

class UserloggedCheck extends StatefulWidget {
  const UserloggedCheck({super.key});

  @override
  State<UserloggedCheck> createState() => _UserloggedCheckState();
}

class _UserloggedCheckState extends State<UserloggedCheck> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isloggedin') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Myapp()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}







