import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final String title;
  final int maxQuantity;
  final Function(int) onQuantityChanged;

  QuantitySelector({
    Key? key,
    required this.title,
    this.maxQuantity = 10,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int _currentQuantity = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<int>(
          value: _currentQuantity,
          items: List.generate(widget.maxQuantity + 1, (index) => DropdownMenuItem(
            value: index,
            child: Text(index.toString()),
          )),
onChanged: (int? newValue) {
  if (newValue != null) {
    setState(() {
      _currentQuantity = newValue;
    });
    widget.onQuantityChanged(newValue);
  }
},

        ),
      ],
    );
  }
}
