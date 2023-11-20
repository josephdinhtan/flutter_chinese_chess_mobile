import 'package:flutter/material.dart';

class DropDownMenu extends StatefulWidget {
  const DropDownMenu(
      {super.key,
      required this.listItem,
      required this.onChange,
      this.initValue});
  final List<String> listItem;
  final String? initValue;
  final Function(String value) onChange;

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String dropdownValue = "";
  bool isUpdated = false;
  @override
  void initState() {
    dropdownValue = widget.listItem.first;
    isUpdated = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initValue != null && !isUpdated) {
      dropdownValue = widget.initValue!;
      isUpdated = true;
    }
    return SizedBox(
      height: 30.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: dropdownValue,
            elevation: 20,
            borderRadius: BorderRadius.circular(10),
            onChanged: (String? value) {
              widget.onChange(value!);
              setState(() {
                dropdownValue = value;
              });
            },
            items:
                widget.listItem.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(value.toString()),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
