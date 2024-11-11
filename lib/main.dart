// ignore_for_file: unnecessary_brace_in_string_interps, prefer_final_fields, use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tugas_1/FileMgr.dart';
import 'package:tugas_1/ImagePage.dart';
import 'package:tugas_1/OpenCamera.dart';

void main() {
  runApp(const KalkulatorApp());
}

class KalkulatorApp extends StatelessWidget {
  const KalkulatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Sederhana',
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900], // Latar belakang gelap
      ),
      home: const KalkulatorPage(),
    );
  }
}

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({Key? key}) : super(key: key);

  @override
  _KalkulatorPageState createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  String _output = "";
  String _operation = "";
  double _num1 = 0.0;
  double _num2 = 0.0;
  List<String> _history = []; // List to store calculation history

  void _btnClicked(String btnText) {
    setState(() {
      if (btnText == "C") {
        _output = "";
        _num1 = 0.0;
        _num2 = 0.0;
        _operation = "";
        _history.clear(); // Clear history when "C" is pressed
      } else if (btnText == "=") {
        _num2 = double.parse(_output);
        String calculation = "";
        if (_operation == "+") {
          _output = (_num1 + _num2).toString();
          calculation =
              "${_num1.toString()} + ${_num2.toString()} = ${_output}";
        } else if (_operation == "-") {
          _output = (_num1 - _num2).toString();
          calculation =
              "${_num1.toString()} - ${_num2.toString()} = ${_output}";
        } else if (_operation == "*") {
          _output = (_num1 * _num2).toString();
          calculation =
              "${_num1.toString()} * ${_num2.toString()} = ${_output}";
        } else if (_operation == "/") {
          _output = (_num1 / _num2).toString();
          calculation =
              "${_num1.toString()} / ${_num2.toString()} = ${_output}";
        }
        _history.insert(0, calculation); // Add calculation to history
        _num1 = double.parse(_output);
        _operation = "";

        // Navigate to ImagePage if result is 4
        if (_output == "4.0") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ImagePage()),
          );
        }

        // Navigate to OpenCamera if result is 6
        if (_output == "6.0") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OpenCamera()),
          );
        }

         // Navigate to FileManager if result is 8
        if (_output == "8.0") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FileMgr()),
          );
        }
      } else {
        if (btnText == "+" ||
            btnText == "-" ||
            btnText == "*" ||
            btnText == "/") {
          _num1 = double.parse(_output);
          _operation = btnText;
          _output = "";
        } else {
          _output += btnText;
        }
      }
    });
  }

  Widget _buildButton(String btnText, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Padding untuk tombol
        child: OutlinedButton(
          onPressed: () => _btnClicked(btnText),
          style: OutlinedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          child: Text(
            btnText,
            style: const TextStyle(fontSize: 24.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Function to show app information dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Kalkulator Sederhana'),
          content: const Text(
              'Nama: Suprayogi\nNIM: 2024150176\n\nAplikasi ini adalah kalkulator sederhana untuk melakukan operasi matematika dasar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Sederhana'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'about') {
                _showAboutDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'about',
                  child: Text('About'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding untuk keseluruhan body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Display the history of calculations
            Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              height: 100, // Set height for history display
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return Text(
                    _history[index],
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.centerRight,
              child: Text(
                _output,
                style: const TextStyle(fontSize: 48.0, color: Colors.white),
              ),
            ),
            Row(
              children: [
                _buildButton("7", Colors.blueAccent),
                _buildButton("8", Colors.blueAccent),
                _buildButton("9", Colors.blueAccent),
                _buildButton("/", Colors.deepOrange),
              ],
            ),
            Row(
              children: [
                _buildButton("4", Colors.blueAccent),
                _buildButton("5", Colors.blueAccent),
                _buildButton("6", Colors.blueAccent),
                _buildButton("*", Colors.deepOrange),
              ],
            ),
            Row(
              children: [
                _buildButton("1", Colors.blueAccent),
                _buildButton("2", Colors.blueAccent),
                _buildButton("3", Colors.blueAccent),
                _buildButton("-", Colors.deepOrange),
              ],
            ),
            Row(
              children: [
                _buildButton("C", Colors.redAccent),
                _buildButton("0", Colors.blueAccent),
                _buildButton("=", Colors.greenAccent),
                _buildButton("+", Colors.deepOrange),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
