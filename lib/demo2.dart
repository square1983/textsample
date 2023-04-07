import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:image_issue/thumb_item.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 这个例子没有问题。。
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});



  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AssetEntity> _assets = [];
  List<File> _images = [];
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build time ${DateTime.now()}}');
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(' ${_images.length} images \n email: ${_emailController.text} \n password: ${_passwordController.text}'),
            SwiperView(images: _images,onRemove: (index){
              setState(() {
                _assets.removeAt(index);
                _images.removeAt(index);
              });
            },),
            EmailInput(emailController: _emailController),
            PasswordInput(passwordController: _passwordController),
          ],
        ),
      ),
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

class SwiperView extends StatelessWidget {
  const SwiperView({Key? key,required this.images,required this.onRemove}) : super(key: key);
  final List<File> images ;
  final Function(int index)? onRemove;
  @override
  Widget build(BuildContext context) {
    return   Container(
      height: 300,
      child: Swiper(
          itemCount: images.length,
          itemBuilder: (BuildContext context,int index){
            return Container(
              margin: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width-32,
                    height: 300,
                    child: ThumbItem(
                      width: MediaQuery.of(context).size.width-32,
                      height: 300, file: images[index],fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: (){
                        onRemove?.call(index);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration:  BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                        ),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(index.toString(),style: TextStyle(color: Colors.white,fontSize: 32),),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}


class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _passwordController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter your password',

        ),
        obscureText: true,
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _emailController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter your email',
        ),
      ),
    );
  }
}
