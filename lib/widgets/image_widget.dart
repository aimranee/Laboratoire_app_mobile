import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageBoxFillWidget extends StatelessWidget {
  final String imageUrl;
  const ImageBoxFillWidget({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return  CachedNetworkImage(
      fit: BoxFit.fill,
      height: double.infinity,
      width: double.infinity,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) =>
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
                //colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
              ),
            ),
          ),
      placeholder: (context, url) => const Center(child: Icon(Icons.image)),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
class ImageBoxContainWidget extends StatelessWidget {
  final String imageUrl;
  const ImageBoxContainWidget({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return      Image(
      image:CachedNetworkImageProvider(imageUrl),
      fit: BoxFit.contain,
      // height: double.infinity,
      // width: double.infinity,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(

            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
      errorBuilder: (BuildContext context, Object exception,
          StackTrace stackTrace) {
        return const Icon(Icons.phonelink_erase_rounded);
      },
    );
  }
}

