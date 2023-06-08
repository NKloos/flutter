import 'package:cpd_ss23/Search/search_companies.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../jobs/jobs_screen.dart';

class BottomNavigationBarForApp extends StatelessWidget {

  int indexNum = 0;

  BottomNavigationBarForApp({required this.indexNum});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.deepOrange.shade400,
        backgroundColor: Colors.blueAccent,
        buttonBackgroundColor: Colors.deepOrange.shade300,
        height: 50,
        items: const [
          Icon(Icons.list, size: 19, color: Colors.black,),
          Icon(Icons.search, size: 19, color: Colors.black,)
        ],
      animationDuration: const Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index){
          if(index == 0){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => JobScreen()));
          } else if (index == 1){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllWorkersScreen()));
          }
      },
    );
  }
}
