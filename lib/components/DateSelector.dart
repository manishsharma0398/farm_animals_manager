import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  final dynamic callback;
  final DateTime date;
  final String value;

  DateSelector({
    this.value,
    this.callback,
    this.date,
  });

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.date != null) selectedDate = widget.date;
  }

  _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.date == null ? DateTime.now() : selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.callback(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(),
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.4,
                  ),
                ),
              ),
              child: Text(widget.value),
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        RaisedButton(
          onPressed: () => _selectDate(), // Refer step 3
          child: Text(
            'Select date',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          color: Colors.greenAccent,
        ),
      ],
    );
  }
}
