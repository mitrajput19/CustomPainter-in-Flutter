import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrawingScreen(),
    );
  }
}

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  String _selectedFont = 'Arial';
  double _selectedFontSize = 20.0;
  Color _selectedColor = Colors.black;
  Offset _position = Offset(50.0, 50.0);
  final List<String> _fontList = ['Arial', 'Times New Roman', 'Courier New'];
  final List<double> _fontSizeList = [15.0, 20.0, 25.0, 30.0];
  List<List> actions = [];

  String displayText = '';
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    actions.add([_selectedFont,_selectedFontSize,_selectedColor]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Celebrare Assignment'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _position += details.delta;
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10,10,10,200),
                child: CustomPaint(
                  painter: MyPainter(
                    selectedFont: actions[index][0],
                    selectedFontSize: actions[index][1],
                    selectedColor: actions[index][2],
                    textPosition: _position,
                    displayText: displayText,
                  ),
                  size: const Size(double.infinity, double.infinity),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    displayText = 'New Text';
                    _selectedFont = 'Arial';
                    _selectedFontSize = 20.0;
                    _selectedColor = Colors.black;
                    _position = Offset(50.0, 50.0);
                    actions.add([_selectedFont,_selectedFontSize,_selectedColor]);
                    index = actions.length-1;
                  });
                },
                child: const Text('Add Text'),
              ),
              DropdownButton<String>(
                value: actions[index][0],
                items: _fontList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFont = newValue!;
                    actions.add([_selectedFont,_selectedFontSize,_selectedColor]);
                    index++;
                  });
                },
              ),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<double>(
                value: actions[index][1],
                items: _fontSizeList.map((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (double? newValue) {
                  setState(() {
                    _selectedFontSize = newValue!;
                    actions.add([_selectedFont,_selectedFontSize,_selectedColor]);
                    index++;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: actions[index][2],
                            onColorChanged: (Color color) {
                              setState(() {
                                _selectedColor = color;
                                actions.add([_selectedFont,_selectedFontSize,_selectedColor]);
                                index++;
                              });
                            },
                            showLabel: true,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Color'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: (){
                print(index);
                if(index>0){
                  setState(() {
                    index=index-1;
                  });
                }
              }, child: const Text("Undo")),
              ElevatedButton(onPressed: (){
                print(index);
                if(index<actions.length-1){
                  setState(() {
                    index=index+1;
                  });
                }
              }, child: const Text("Redo")),
            ],
          )
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final String selectedFont;
  final double selectedFontSize;
  final Color selectedColor;
  final String displayText;
  final Offset textPosition;

  MyPainter({
    required this.selectedFont,
    required this.selectedFontSize,
    required this.selectedColor,
    required this.displayText,
    required this.textPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {

    final textPainter = TextPainter(
      text: TextSpan(
        text: displayText,
        style: TextStyle(
          color: selectedColor,
          fontSize: selectedFontSize,
          fontFamily: selectedFont,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);


    textPainter.paint(canvas,textPosition);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
