import 'dart:io';

import 'package:flutter/material.dart';

class ThumbItem extends StatelessWidget {
  const ThumbItem({Key? key,required this.file, required this.width, required this.height, this.fit}) : super(key: key);
  final double? width ;
  final double? height ;
  final File file;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return  Image.file(file,
      width: width,
      height: height,
      cacheWidth: width==null?null: (width!*MediaQuery.of(context).devicePixelRatio).toInt(),
      cacheHeight:height ==null?null:(height!*MediaQuery.of(context).devicePixelRatio).toInt(),
      fit: BoxFit.cover,);
  }
}
