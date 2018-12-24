import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gameState.dart';

class WelcomePage extends StatefulWidget{
  @override
  _WelcomePageState createState() => new _WelcomePageState();
}

class  _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin{

  static const int duration= 2500;
  static const double maxValue=100.0;
  int animationToPlay=0;
  Animation<double> animation;
  AnimationController controller;
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: duration), vsync: this);
    animation = Tween(begin: 0.0, end: maxValue).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.000,
          curve: Curves.easeInOut,
        ),
      ),
    )..addListener(() {
      setState(() {
        // the state that has changed here is the animation object’s value
      });
    })
    ..addStatusListener(handler);
    controller.forward();
  }

  void handler(status) {
    print("Status" + status.toString() + animationToPlay.toString());
    if (status == AnimationStatus.completed) {
      if(animationToPlay<3){
        animationToPlay++;
        controller.reset();
        controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: null,
      body: _buildWelcomePage(),
    );
  }
 _buildWelcomePage() {
   return _getCurrentAnimation();
 }
 _getCurrentAnimation() {
   switch (animationToPlay) {
     case 0:
       return _getIntroduction();

       break;
     case 1:
       return _getIntroduction();
       break;
     case 2:
       return Container(
             color: Colors.black,
         child: Opacity(
           opacity: animation.value/maxValue,
           child: Center(
             child: Text('For Jacqueline',
               style: TextStyle(fontSize: 25, color: Colors.white),),
           ),
         ),
       );
     case 3:
       return _getTree();
       break;

   }
 }

 _getIntroduction(){
   return Container(
     color: Colors.black,
     child: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Opacity(
             opacity: animationToPlay==0?animation.value/maxValue:1.0,
             child:
             Text('Welcome',
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 25, color: Colors.white),),
           ),
           Opacity(
             opacity: animationToPlay==1?animation.value/maxValue:0.0,
             child:
             Text('To The Garden You Love',
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 25, color: Colors.white),),
           ),
         ],
       ),
     ),
   );
 }

 _getTree(){
    return Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
            image: AssetImage('assets/Tree.png'),
          ),
        ),
      child:Center(
        child: Container(
          padding: EdgeInsets.only(top: 400.0),
          child: GestureDetector(
              onTap: ()=>_goToHome(),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(color: Colors.green, border: Border.all(color: Colors.black54,width: 5.0)),
              child: Text('Start',
              style: TextStyle(fontSize: 24.0,color: Colors.black),),
              ),
          ),
        ),
      ),
    );
 }
 _goToHome(){
    _loadData();
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => MyHomePage()),
   );
 }

  _loadData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool doneTorial=(prefs.getBool('doneTutorial')??false);
    print('did tutorial? $doneTorial');
    GameInfoState state = GameInfo.of(context);
    state.setTutorial(doneTorial);
  }
}