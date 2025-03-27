import 'package:flutter/material.dart';

class FlowerKeyboardPage extends StatefulWidget {
  const FlowerKeyboardPage({Key? key}) : super(key: key);

  @override
  _FlowerKeyboardPageState createState() => _FlowerKeyboardPageState();
}

class _FlowerKeyboardPageState extends State<FlowerKeyboardPage> {
  final Map<String, String> flowerMap = {
    'A': 'assets/flowers/A.png',
    'B': 'assets/flowers/B.png',
    'C': 'assets/flowers/C.png',
    'D': 'assets/flowers/D.png',
    'E': 'assets/flowers/E.png',
    'F': 'assets/flowers/F.png',
    'G': 'assets/flowers/G.png',
    'H': 'assets/flowers/H.png',
    'I': 'assets/flowers/I.png',
    'J': 'assets/flowers/J.png',
    'K': 'assets/flowers/K.png',
    'L': 'assets/flowers/L.png',
    'M': 'assets/flowers/M.png',
    'N': 'assets/flowers/N.png',
    'O': 'assets/flowers/O.png',
    'P': 'assets/flowers/P.png',
    'Q': 'assets/flowers/Q.png',
    'R': 'assets/flowers/R.png',
    'S': 'assets/flowers/S.png',
    'T': 'assets/flowers/T.png',
    'U': 'assets/flowers/U.png',
    'V': 'assets/flowers/V.png',
    'W': 'assets/flowers/W.png',
    'X': 'assets/flowers/X.png',
    'Y': 'assets/flowers/Y.png',
    'Z': 'assets/flowers/Z.png',


    // Add more mappings as needed
  };

  String enteredText = '';
  List<String> flowerImages = [];

  void _onKeyPress(String letter) {
    setState(() {
      enteredText += letter;
      if (flowerMap.containsKey(letter)) {
        flowerImages.add(flowerMap[letter]!);
      }
    });
  }

  void _reset() {
    setState(() {
      enteredText = '';
      flowerImages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flower Keyboard'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
          ),
        ],
      ),
      body: Column(
        children: [
          // Display entered text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Entered Text: $enteredText',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0), // Thêm khoảng cách giữa các câu
                const Text(
                  'Tên của bạn sẽ bao gồm các loại hoa dưới đây:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Display flowers
          Expanded(
            child: Center(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: flowerImages
                    .map((imagePath) => Image.asset(imagePath, width: 60, height: 60))
                    .toList(),
              ),
            ),
          ),

          // Keyboard
          Container(
            padding: const EdgeInsets.all(10.0),
            color: Colors.grey[200],
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: flowerMap.keys.map((letter) {
                return ElevatedButton(
                  onPressed: () => _onKeyPress(letter),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text(letter, style: const TextStyle(fontSize: 18)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

}

