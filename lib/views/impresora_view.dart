import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:impresora/clases/class_impresora.dart';
import 'package:provider/provider.dart';

class ImpresoraView extends StatefulWidget {
  const ImpresoraView({Key key}) : super(key: key);

  @override
  State<ImpresoraView> createState() => _ImpresoraViewState();
}

class _ImpresoraViewState extends State<ImpresoraView> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice _device;
  String tips = 'Dispositivo desconectado';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    print('aaaaaaaaaaaaaaaaaaaa ${ProviderImpresora().Nantena}');
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected=await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      print('cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'Se aconectado correctamente';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'Se a desconectador correctamente';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if(isConnected) {
      setState(() {
        _connected=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    ProviderImpresora imprimir = arguments['impresora'];
    print('impresora ${imprimir.Nantena}');
    return Scaffold(
      appBar: AppBar(
        title:Text('Imprimir'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            bluetoothPrint.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(tips),
                  ),
                ],
              ),
              Divider(),
              StreamBuilder<List<BluetoothDevice>>(
                stream: bluetoothPrint.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data.map((d) => ListTile(
                    title: Text(d.name??''),
                    subtitle: Text(d.address),
                    onTap: () async {
                      setState(() {
                        _device = d;
                      });
                    },
                    trailing: _device!=null && _device.address == d.address?Icon(
                      Icons.check,
                      color: Colors.green,
                    ):null,
                  )).toList(),
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          child: Text('Conectar'),
                          onPressed:  _connected?null:() async {
                            if(_device!=null && _device.address !=null){
                              await bluetoothPrint.connect(_device);
                            }else{
                              setState(() {
                                tips = 'Selecciona el dispositivo';
                              });
                              print('please select device');
                            }
                          },
                        ),
                        SizedBox(width: 10.0),
                        OutlinedButton(
                          child: Text('Desconectar'),
                          onPressed:  _connected?() async {
                            await bluetoothPrint.disconnect();
                          }:null,
                        ),
                      ],
                    ),
                    OutlinedButton(
                      child: Text('Imprimir'),
                      onPressed:  _connected?() async {
                        Map<String, dynamic> config = Map();
                        List<LineText> list = [];
                        ByteData data = await rootBundle.load("assets/logo.png",);
                        List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
                        String base64Image = base64Encode(imageBytes);
                        list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_RIGHT, linefeed: 1,height: 500,width:375));

                        //ByteData data = await rootBundle.load("assets/logo.jpeg");
                        //List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
                        //String base64Image = base64Encode(imageBytes);
                        //list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_LEFT, linefeed: 1));
                        //list.add(LineText(linefeed: 1));

                        list.add(LineText(type: LineText.TYPE_TEXT, content: 'Comrpobante', weight: 1, align: LineText.ALIGN_CENTER,linefeed: 1));
                        list.add(LineText(linefeed: 1));
                        list.add(LineText(type: LineText.TYPE_TEXT, content: 'Folio: ', weight: 0, align: LineText.ALIGN_LEFT,));
                        list.add(LineText(type: LineText.TYPE_TEXT, content: '${imprimir.folio}', weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));
                        list.add(LineText(linefeed: 1));
                        list.add(LineText(type: LineText.TYPE_TEXT, content: 'Nombre: ', weight: 0, align: LineText.ALIGN_LEFT,));
                        list.add(LineText(type: LineText.TYPE_TEXT, content: '${imprimir.nombre} ', weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));
                        list.add(LineText(linefeed: 1));
                        list.add(LineText(type: LineText.TYPE_TEXT, content: 'Numero de antena: ', weight: 0, align: LineText.ALIGN_LEFT,));
                        list.add(LineText(type: LineText.TYPE_TEXT, content: '${imprimir.Nantena}', weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));
                        list.add(LineText(linefeed: 1));

                        list.add(LineText(type: LineText.TYPE_TEXT, content: 'Comentario ', weight: 0, align: LineText.ALIGN_LEFT,));
                        list.add(LineText(type: LineText.TYPE_TEXT, content: '${imprimir.coment}', weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));
                        list.add(LineText(linefeed: 1));
                        list.add(LineText(type: LineText.TYPE_TEXT, content: 'Direccion: ', weight: 0, align: LineText.ALIGN_LEFT,));
                        list.add(LineText(type: LineText.TYPE_TEXT, content: 'Carr. Manzanillo-Chandiablo #166, Plaza Alta  L-4 Fracc. Los Altos', weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));
                        list.add(LineText(linefeed: 1));
                        list.add(LineText(type: LineText.TYPE_TEXT, content: 'Telefono: ', weight: 0, align: LineText.ALIGN_LEFT,));
                        list.add(LineText(type: LineText.TYPE_TEXT, content: '3141655251', weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));
                        list.add(LineText(linefeed: 1));


                        await bluetoothPrint.printReceipt(config, list);
                      }:null,
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: bluetoothPrint.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => bluetoothPrint.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}