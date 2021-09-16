import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  bool isBusy = false;
  String process_text="";
  static const platform = MethodChannel('samples.flutter.dev/battery');

  String _batteryLevel = 'Unknown battery level.';
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  final ImagePicker _picker = ImagePicker();
  @override
  void dispose() async {
    super.dispose();
    await textDetector.close();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: Text(process_text,style:  TextStyle(fontSize: 20),)),
            ElevatedButton(
              child: Text('Get Battery Level'),
              onPressed: _getBatteryLevel,
            ),
            Text(_batteryLevel),

            ElevatedButton(
              child: Text('show ezzat toast'),
              onPressed: () async{
                Map m=Map();
                m["name"]="ali";
                m["age"]=13;
              String res= await platform.invokeMethod("showToast",m);
              print(res);
              },
            ),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final XFile photo = await _picker.pickImage(source: ImageSource.camera);
          File file = File(photo.path);
      InputImage image=InputImage.fromFile(file);
          processImage(image);



        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    setState(() {
      process_text="انتظر لحظات من فضلك";
    });

    final recognisedText = await textDetector.processImage(inputImage);
    print("yesssssssss");
    print(recognisedText.text);
    setState(() {
      process_text=recognisedText.text;
    });
    print("yesssssssss");
    print('Found ${recognisedText.blocks.length} textBlocks');
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {

 //   print(recognisedText);

    } else {
      //print("nullll");

    }

  }
}
