import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart'; // Import barcode_scan2
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool isDarkTheme = false;
  TextEditingController textField1Controller = TextEditingController();
  TextEditingController textField2Controller = TextEditingController();
  String popupMessage = '';
  bool areBothFieldsFilled = false;
  bool isLoading = false;

  Future<void> scanBarcode(TextEditingController controller) async {
    var result = await BarcodeScanner
        .scan(); // Menggunakan barcode_scan2 untuk memindai barcode
    if (result.rawContent.isNotEmpty) {
      setState(() {
        controller.text =
            result.rawContent; // Menyimpan hasil scan ke dalam TextField
        areBothFieldsFilled = textField1Controller.text.isNotEmpty &&
            textField2Controller.text.isNotEmpty;
      });
    }
  }

  void clearTextField(TextEditingController controller) {
    setState(() {
      controller.clear();
      areBothFieldsFilled = textField1Controller.text.isNotEmpty &&
          textField2Controller.text.isNotEmpty;
    });
  }

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  void checkFrameMatch() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      String text1 = textField1Controller.text;
      String text2 = textField2Controller.text;

      setState(() {
        popupMessage =
            text1 == text2 ? 'Nomor frame cocok' : 'Nomor frame tidak cocok';
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hasil'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  popupMessage == 'Nomor frame cocok'
                      ? 'assets/animasi_ceklis.json'
                      : 'assets/animasi_x.json',
                  height: 100,
                ),
                SizedBox(height: 16),
                Text(popupMessage),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tutup'),
              ),
            ],
          );
        },
      );

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Matching Barcode'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode),
              onPressed: toggleTheme,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Lottie.asset(
                  'assets/animasi_car.json',
                  height: 250,
                  repeat: true,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: textField1Controller,
                  onChanged: (value) {
                    setState(() {
                      areBothFieldsFilled =
                          textField1Controller.text.isNotEmpty &&
                              textField2Controller.text.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nomor Frame 1',
                    prefixIcon: IconButton(
                      icon: Icon(Icons.qr_code_scanner),
                      onPressed: () => scanBarcode(textField1Controller),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () => clearTextField(textField1Controller),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: textField2Controller,
                  onChanged: (value) {
                    setState(() {
                      areBothFieldsFilled =
                          textField1Controller.text.isNotEmpty &&
                              textField2Controller.text.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nomor Frame 2',
                    prefixIcon: IconButton(
                      icon: Icon(Icons.qr_code_scanner),
                      onPressed: () => scanBarcode(textField2Controller),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () => clearTextField(textField2Controller),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                OutlinedButton(
                  onPressed: isLoading || !areBothFieldsFilled
                      ? null
                      : checkFrameMatch,
                  child: isLoading
                      ? Lottie.asset(
                          'assets/animasi_loading.json',
                          width: 50,
                          height: 50,
                          repeat: true,
                        )
                      : Text('Cek'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        areBothFieldsFilled ? Colors.blue : Colors.transparent,
                    foregroundColor: areBothFieldsFilled
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    side: areBothFieldsFilled
                        ? BorderSide(color: Colors.grey)
                        : BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
