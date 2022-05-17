import 'dart:isolate';
import 'dart:ui';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/style.dart';
import 'package:laboratoire_app/utilities/toastMsg.dart';
import 'package:laboratoire_app/widgets/imageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swipedetector/swipedetector.dart';

class ShowPrescriptionFilePage extends StatefulWidget {
  final title;
  final fileUrls;
  final int selectedFilesIndex;
  const ShowPrescriptionFilePage({Key key, this.fileUrls, this.title, this.selectedFilesIndex})
      : super(key: key);
  @override
  _ShowPrescriptionFilePageState createState() => _ShowPrescriptionFilePageState();
}

class _ShowPrescriptionFilePageState extends State<ShowPrescriptionFilePage> {
  String _selectedFileUrl = "";
  int totalImg = 0;
  int _index = 0;
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    // TODO: implement initState
    print(widget.fileUrls.length);
    //initialize all value
    setState(() {
      _selectedFileUrl = widget.fileUrls[widget.selectedFilesIndex];
      totalImg = widget.fileUrls.length;
      _index = widget.selectedFilesIndex;
    });
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // String id = data[0];
      // DownloadTaskStatus status = data[1];
      // int progress = data[2];
      setState((){ });
    });
    FlutterDownloader.registerCallback(downloadCallback);

    super.initState();
  }
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(widget.title,style: kAppbarTitleStyle),
        centerTitle: true,
        backgroundColor: appBarColor,
        actions: [
          IconButton(onPressed: ()  async{
            var perStatus = await Permission.storage.request();
            if(perStatus.isGranted) {
              final externalDir=await getExternalStorageDirectory();
              ToastMsg.showToastMsg("Download Stated");
              await FlutterDownloader.enqueue(
                url: _selectedFileUrl,
                savedDir: externalDir.path,
                fileName:DateTime.now().millisecondsSinceEpoch.toString(),
                showNotification: true, // show download progress in status bar (for Android)
                openFileFromNotification: true, // click on notification to open downloaded file (for Android)
              );
            }
          }, icon: const Icon(Icons.download_rounded,))
        ],
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          //color: Colors.red,
          child: Stack(
            children: [
              SwipeDetector(
                onSwipeLeft: () {
                  _forwardImg();
                },
                onSwipeRight: () {
                  _backwardImg();
                },
                child: Center(
                    child: ImageBoxContainWidget(imageUrl:_selectedFileUrl )
                  //get file from url
                ),
              ),
              widget.fileUrls.indexOf(_selectedFileUrl)!= totalImg-1? Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey,
                        child: IconButton(
                          onPressed: _forwardImg,
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  )):Container(),
              widget.fileUrls.indexOf(_selectedFileUrl)>0? Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey,
                        child: IconButton(
                          onPressed: _backwardImg,
                          icon: const Icon(
                            Icons.arrow_back_ios_sharp,
                            color: Colors.black,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  )):Container()
            ],
          ),
        ));
  }

  void _forwardImg() {
    // print(_index);
    //print(totalImg);
    if (_index + 1 <= totalImg - 1) {
      // check more images is remain or not by indexes
      setState(() {
        _selectedFileUrl = widget.fileUrls[_index + 1]; // if true then set forward to new image by increment the index
      });
    }
    if (_index + 1 < totalImg) {
      setState(() {
        _index = _index + 1; // increment index value by one so user can forward to other remain images
      });
    }
  }

  void _backwardImg() {
    if (_index - 1 >= 0) {
      //if value is less then 0 then it show error show we are checking the value
      setState(() {
        _selectedFileUrl = widget.fileUrls[_index - 1]; // if upper condition is true then decrement the index value and show just backward image
        _index = _index - 1;
      });
    }
  }
}
