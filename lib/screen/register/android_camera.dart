import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../widget/app_bar/custom_appBar.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:mrz_parser/mrz_parser.dart';

import 'package:image/image.dart' as imglib;

class AndroidCameraPage extends StatefulWidget {
  AndroidCameraPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AndroidCameraPageState createState() => _AndroidCameraPageState();
}

class _AndroidCameraPageState extends State<AndroidCameraPage> {
  CameraController _camera;
  bool _cameraInitialized = false;
  bool _processing = false;
  String texts = '';
  final textRecognizer = FirebaseVision.instance.textRecognizer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<Uint8List> convertImagetoPng(CameraImage image) async {
    try {
      imglib.Image img;
      if (image.format.group == ImageFormatGroup.yuv420) {
        img = _convertYUV420(image);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        img = _convertBGRA8888(image);
      }
      //imglib.bakeOrientation(img);
      img = imglib.copyRotate(img, -90);

      //img = imglib.copyCrop(img, 0, (image.height * 0.3).toInt(), image.width, (image.height * 0.6).toInt());
      //return img.getBytes();
      imglib.PngEncoder pngEncoder = new imglib.PngEncoder();

      // // Convert to png
      List<int> png = pngEncoder.encodeImage(img);
      return Uint8List.fromList(png);
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  // CameraImage BGRA8888 -> PNG
  // Color
  imglib.Image _convertBGRA8888(CameraImage image) {
    return imglib.Image.fromBytes(
      image.width,
      image.height,
      image.planes[0].bytes,
      format: imglib.Format.bgra,
    );
  }

  // CameraImage YUV420_888 -> PNG -> Image (compresion:0, filter: none)
  // Black
  imglib.Image _convertYUV420(CameraImage image) {
    var img = imglib.Image(image.width, image.height); // Create Image buffer

    Plane plane = image.planes[0];
    const int shift = (0xFF << 24);

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < image.width; x++) {
      for (int planeOffset = 0;
          planeOffset < image.height * image.width;
          planeOffset += image.width) {
        final pixelColor = plane.bytes[planeOffset + x];
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        // Calculate pixel color
        var newVal =
            shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

        img.data[planeOffset + x] = newVal;
      }
    }

    return img;
  }

  static Uint8List _concatenatePlanes(List<Plane> planes) {
    final allBytes = WriteBuffer();
    for (Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  void _initializeCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _camera = CameraController(cameras[0], ResolutionPreset.high);
    _camera.initialize().then((_) async {
      await Future.delayed(Duration(milliseconds: 300));
      await _camera.startImageStream(_process);
      setState(() {
        _cameraInitialized = true;
      });
    });
  }

  List<String> _splitRecognized(String recognizedText) {
    final s = recognizedText.replaceAll(' ', '');
    return s.split('\n').where((s) => s.isNotEmpty && s.length > 25).toList();
  }

  FirebaseVisionImageMetadata _buildMetaData(
      CameraImage image, ImageRotation rotation) {
    return FirebaseVisionImageMetadata(
      rawFormat: image.width,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      planeData: image.planes.map(
        (Plane plane) {
          return FirebaseVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );
  }

  void _process(CameraImage image) async {
    if (!_processing) {
      _processing = true;
      //print('processing');
      final data = _concatenatePlanes(image.planes);
      try {
        final fimage = FirebaseVisionImage.fromBytes(
            data, _buildMetaData(image, ImageRotation.rotation90));
        textRecognizer.processImage(fimage).then((rec) async {
          try {
            final list = _splitRecognized(rec.text);
            for (int i = 0; i < list.length - 1; i++) {
              final sublist = list.sublist(i, i + 2);
              final result = MRZParser.tryParse(sublist);
              if (result != null) {
                Navigator.pop(context, result);
                break;
              }
            }
            _processing = false;
          } catch (ex) {
            _processing = false;
          }
        });
      } catch (ex) {
        _processing = false;
      }
    }
  }

  @override
  void dispose() async {
    // await _camera.stopImageStream();
    await _camera.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(children: [
          _cameraInitialized
              ? CameraPreview(_camera)
              :
              // Transform.scale(
              //   scale: _camera.value.aspectRatio / deviceRatio,
              //   child: AspectRatio(
              //   aspectRatio: _camera.value.aspectRatio,
              //   child: CameraPreview(_camera)),
              // ) :
              Container(),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CustomAppBar(
              title: 'Сканирование ПИНФЛ',
              textColor: Colors.white,
              backgroundColor: Colors.transparent,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(5)),
            ),
            Padding(
              padding: const EdgeInsets.all(38),
              child: Text(
                  'Поместите ваш документ в рамку.\nУбедитесь, что все данные четко видны',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .apply(color: Colors.white)),
            ),
          ]),
        ]),
      ),
    );
  }
}
