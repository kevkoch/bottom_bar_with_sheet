import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final assetsAudioPlayer = AssetsAudioPlayer();
  double currentPlayedat = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Place for your content")),
      bottomNavigationBar: BottomBarWithSheet(
        isAudioPlayer: true,
        audioName: "Test",
        audioDuration: currentPlayedat.toString(),
        disableMainActionButton: true,
        selectedIndex: _selectedIndex,
        sheetChild: Center(child: Text("Place for your another content")),
        bottomBarTheme: BottomBarTheme(
          nonselectedItemPadding: 5,
          selectedItemIconSize: 60,
          selectedItemIconColor: Color(0xFFbc13fe),
          itemIconColor: Colors.grey,
          height: MediaQuery.of(context).size.height*0.9,
          heightClosed: 200
        ),
        backgroundBoxColor: Colors.grey[200],
        currentDuration: 20,
        percentage: 50,

        icon: Icon(Icons.play_arrow),
        onPressedAudioPlayer: (){
        },
        mainActionButtonTheme: MainActionButtonTheme(
        ),
        onSelectItem: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomBarWithSheetItem(pngPath: "assets/img/smile.png",icon: null,selectedBackgroundColor: Colors.green,itemIconColor: Colors.red),
          BottomBarWithSheetItem(icon: Icons.shopping_cart),
          BottomBarWithSheetItem(icon: Icons.settings),
          BottomBarWithSheetItem(icon: Icons.favorite),
        ],
      ),
    );
  }
}
