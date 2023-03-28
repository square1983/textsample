import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_issue/thumb_item.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AssetEntity> _assets = [];
  List<File> _images = [];


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (BuildContext context,int index){
        return ThumbItem(
          width: MediaQuery.of(context).size.width-32,
          height: 300, file: _images[index],
        );
      }, separatorBuilder: (BuildContext context,int index){
        return const SizedBox(height: 16,);
      }, itemCount: _images.length),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImages,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _pickImages() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(),
    );
    if (result == null) return;
    _assets.addAll(result);

    _images.addAll(await Future.wait(result.map((AssetEntity? e) => e?.file.then((File? f) => f!) ?? Future.value(null))));

    setState(() {});
  }
}
