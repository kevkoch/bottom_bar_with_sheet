import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bottom_bar_with_sheet v0.5.1',
            style: TextStyle(color: Colors.white)),
      ),
      body: Center(child: Text("Place for your content")),
      bottomNavigationBar: BottomBarWithSheet(
        isAudioPlayer: true,
        audioName: "Test",
        disableMainActionButton: true,
        selectedIndex: _selectedIndex,
        sheetChild: Center(child: Text("Place for your another content")),
        bottomBarTheme: BottomBarTheme(
          nonselectedItemPadding: 5,
          selectedItemIconSize: 60,
          selectedItemIconColor: Color(0xFFbc13fe),
          itemIconColor: Colors.grey,
          height: 200,
          heightClosed: 200
        ),
        percentage: 50,
        icon: Icon(Icons.play_arrow),
        onPressedAudioPlayer: (){},
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
