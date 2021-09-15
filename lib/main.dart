import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  bool isBusy = false;

  String process_text="";
  CustomPaint? customPaint;
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
            Center(child: Text(process_text,style:  TextStyle(fontSize: 20),))


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
          File file = File(photo!.path);
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
