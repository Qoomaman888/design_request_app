import 'package:flutter/material.dart';

DropdownButton<int> buildFloorDropdown(
    int currentValue, int maxFloor, Function(int?) onChanged, {required bool isUnderground}) {
  return DropdownButton<int>(
    value: currentValue,
    items: List.generate(maxFloor, (index) => index + 1).map((int value) {
      return DropdownMenuItem<int>(
        value: value,
        child: Text('$value F'),
      );
    }).toList(),
    onChanged: (value) => onChanged(value),
  );
}
