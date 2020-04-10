import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  GlobalKey qrkey = GlobalKey();
  var qrText = "";
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
          children:
          <Widget>[
        Expanded(
          flex: 1,
          child: Center(
            child: Text("Por favor apuntar hacia el QR"),
          ),
        ),
        Expanded(
          flex: 5,
          child:  QRView(key: qrkey,
              overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderColor: Colors.lightGreen,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
              onQRViewCreated: _onQRViewCreated,

          ),
          ),
            Expanded(
          child: Center(
              child: Text("Lectura: $qrText")
          )
        )
      ]),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  static Future<void> vibrate() async {
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData){
      setState(() {
        qrText = scanData;
        vibrate();
      });
    });
  }
}
