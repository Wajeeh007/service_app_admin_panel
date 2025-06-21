import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../images_paths.dart';

class CustomNetworkImage extends StatelessWidget {
  final double height;
  final double width;
  final String imageUrl;
  final double radius;
  final BoxFit boxFit;

  const CustomNetworkImage({
    super.key,
    this.height = 70,
    this.width = 70,
    required this.imageUrl,
    this.radius = 8,
    this.boxFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(
              image: imageProvider,
              fit: boxFit,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(
              image: AssetImage(ImagesPaths.imagePlaceholder),
              fit: boxFit,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return const Center(
          child: CircularProgressIndicator(strokeWidth: 0.5),
        );
      },
    );
  }
}
