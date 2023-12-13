import 'package:flutter/material.dart';

DropdownButton<int> buildFloorDropdown(
    int currentValue, int maxFloor, Function(int?) onChanged,
    {bool isUnderground = false}) {
  return DropdownButton<int>(
    value: currentValue,
    items: List.generate(maxFloor, (index) {
      String displayValue = isUnderground ? 'B${index + 1}F' : '${index + 1} F';
      return DropdownMenuItem<int>(
        value: index + 1,
        child: Text(displayValue),
      );
    }).toList(),
    onChanged: (value) => onChanged(value),
  );
}
