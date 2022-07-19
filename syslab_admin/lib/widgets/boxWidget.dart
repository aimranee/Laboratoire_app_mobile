import 'package:flutter_svg/flutter_svg.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/widgets/imageWidget.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';

class CircularCameraIconWidget extends StatelessWidget {
  @required
  final onTap;
  CircularCameraIconWidget({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        child: GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child:
                const Icon(Icons.camera_enhance_rounded, size: 50, color: iconsColor),
          ),
        ),
      ),
    );
  }
}

class RectCameraIconWidget extends StatelessWidget {
  @required
  final onTap;
  RectCameraIconWidget({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        color: Colors.grey[200],
        child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child:
                const Icon(Icons.camera_enhance_rounded, size: 50, color: iconsColor),
          ),
        ),
      ),
    );
  }
}

class CircularImageWidget extends StatelessWidget {
  @required
  final images;
  @required
  final onPressed;
  CircularImageWidget({this.onPressed, this.images});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        //  color: Colors.green,
        child: Stack(
          children: <Widget>[
            // ClipOval(
            //   child: AssetThumb(
            //     asset: images[0],
            //     height: 150,
            //     width: 150,
            //   ),
            // ),
            Positioned(
                top: -5,
                right: -10,
                child: IconButton(
                  onPressed: onPressed,
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class RectImageWidget extends StatelessWidget {
  @required
  final images;
  @required
  final onPressed;
  RectImageWidget({this.onPressed, this.images});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        //  color: Colors.green,
        child: Stack(
          children: <Widget>[
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8.0),
            //   child: AssetThumb(
            //     asset: images[0],
            //     height: 150,
            //     width: 150,
            //   ),
            // ),
            Positioned(
                top: -5,
                right: -10,
                child: IconButton(
                  onPressed: onPressed,
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class ECircularCameraIconWidget extends StatelessWidget {
  @required
  final onTap;
  ECircularCameraIconWidget({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        child: GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.camera_enhance_rounded,
                size: 50, color: primaryColor),
          ),
        ),
      ),
    );
  }
}

class ERectCameraIconWidget extends StatelessWidget {
  @required
  final onTap;
  ERectCameraIconWidget({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        color: Colors.grey[200],
        child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: const Icon(Icons.camera_enhance_rounded,
                size: 50, color: primaryColor),
          ),
        ),
      ),
    );
  }
}

class ECircularImageWidget extends StatelessWidget {
  @required
  final images;
  @required
  final onPressed;
  @required
  final String imageUrl;
  ECircularImageWidget({this.onPressed, this.images, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        //  color: Colors.green,
        child: Stack(
          children: <Widget>[
            // ClipOval(
            //     child: imageUrl == ""
            //         ? AssetThumb(
            //             asset: images[0],
            //             height: 150,
            //             width: 150,
            //           )
            //         //:Container()
            //         : ImageBoxFillWidget(
            //             imageUrl: imageUrl,
            //           ) //recommended use 200*200 pixel

            //     ),
            Positioned(
                top: -5,
                right: -10,
                child: IconButton(
                  onPressed: onPressed, //remove image form the array

                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class ERectImageWidget extends StatelessWidget {
  @required
  final images;
  @required
  final onPressed;
  @required
  final String imageUrl;
  ERectImageWidget({this.onPressed, this.images, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 150,
        width: 150,
        //  color: Colors.green,
        child: Stack(
          children: <Widget>[
            // ClipRRect(
            //     borderRadius: BorderRadius.circular(8.0),
            //     child: imageUrl == ""
            //         ? AssetThumb(
            //             asset: images[0],
            //             height: 150,
            //             width: 150,
            //           )
            //         //:Container()
            //         : ImageBoxFillWidget(
            //             imageUrl: imageUrl,
            //           ) //recommended use 200*200 pixel

            //     ),
            Positioned(
                top: -5,
                right: -10,
                child: IconButton(
                  onPressed: onPressed, //remove image form the array

                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class CircularUserImageWidget extends StatelessWidget {
  @required
  final userList;
  const CircularUserImageWidget({Key key, this.userList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: ClipOval(
        child: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: SvgPicture.asset(
            "assets/icons/patient.svg", 
            semanticsLabel: 'Acme Logo'
          ),
        )
      )
    );
  }
}

class SearchBoxWidget extends StatelessWidget {
  final controller;
  final hintText;
  final validatorText;
  const SearchBoxWidget({Key key, this.controller, this.hintText, this.validatorText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: TextFormField(
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        controller: controller,
        validator: (item) {
          return item.isNotEmpty ? null : validatorText;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white),
            hoverColor: Colors.red,
            fillColor: Colors.orangeAccent,

            // prefixIcon:Icon(Icons.,),
            //   labelText: "Full Name",
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: appBarColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: appBarColor, width: 1.0),
            )),
      ),
    );
  }
}
