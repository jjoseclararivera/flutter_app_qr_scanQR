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
          flex: 2,
          child: Center(
            child: Text("Favor apuntar al QR del Cliente: $qrText"
            , style: TextStyle(fontSize: 15.0),))
               ),
        Expanded(
          flex:15,
          child: Center(
            child: Container(child:  QRView(key: qrkey,
              overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderColor: Colors.lightBlueAccent,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
              onQRViewCreated: _onQRViewCreated,
          )))
          ),
          
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
