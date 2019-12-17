import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;
  bool isFlashOn = false;
  bool isFrontCamera = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scan"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: isFlashOn ? Icon(Icons.flash_on) : Icon(Icons.flash_off),
            onPressed: toggleFlash,
          ),
          IconButton(
            icon: isFrontCamera
                ? Icon(Icons.camera_front)
                : Icon(Icons.camera_rear),
            onPressed: flipCamera,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Center(
              child: QRView(
                key: qrKey,
                overlay: QrScannerOverlayShape(
                  borderRadius: 10,
                  borderColor: Colors.red,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan result: $qrText'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void pauseCamera() {
    this.controller.pauseCamera();
  }

  void resumeCamera() {
    this.resumeCamera();
  }

  void flipCamera() {
    this.controller.flipCamera();
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
  }

  void toggleFlash() {
    this.controller.toggleFlash();
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }
}
