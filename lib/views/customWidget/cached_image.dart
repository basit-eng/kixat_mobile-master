import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CpImage extends StatelessWidget {
  final String url;
  final double height, width;
  final BoxFit fit;

  CpImage({ @required this.url, this.height, this.width, this.fit});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      errorWidget: (context, url, error) => Image.asset('assets/error.png'),
      placeholder: (context, url) => Image.asset('assets/placeholder.png'),
      imageUrl: url,
      fit: this.fit,
      height: height,
      width: width,
    );
  }
}