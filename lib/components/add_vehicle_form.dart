import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/form_helpers.dart';

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({super.key});

  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  final _formKey = GlobalKey<FormState>();

  final DateTime _curr = DateTime.now();

  String? _make;
  String? _model;
  String? _name;
  int? _year;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Your full name",
                  hintText: "Enter your first and last name"),
              onSaved: (String? value) {
                setState(() => _name = value);
              },
              validator: (value) {
                if (FormHelpers.stringFieldValidatorCondition(value)) {
                  return "Please enter your full name";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Make",
                  hintText: "Enter the Make of your vehicle"),
              onSaved: (String? value) {
                setState(() => _make = value);
              },
              validator: (value) {
                if (FormHelpers.stringFieldValidatorCondition(value)) {
                  return "Please enter the Make of your vehicle";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Model",
                  hintText: "Enter the Model of your vehicle"),
              onSaved: (String? value) {
                setState(() => _model = value);
              },
              validator: (value) {
                if (FormHelpers.stringFieldValidatorCondition(value)) {
                  return "Please enter the Make of your vehicle";
                }
                return null;
              },
            ),
            DropdownButtonFormField<int>(
              items: FormHelpers.generateYearsForDropdown()
                  .map((int year) => DropdownMenuItem(
                      value: year, child: Text(year.toString())))
                  .toList(),
              onChanged: (selectedYear) {
                setState(() {
                  _year = selectedYear;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select a year',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null) {
                  return "Please select the year of your vehicle";
                }
                return null;
              },
            ),
            FormField<DateTime>(
                validator: FormHelpers.validateDate,
                builder: (FormFieldState<DateTime> field) {
                  return InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _checkInDate ?? _curr,
                          firstDate: DateTime(_curr.year),
                          lastDate: DateTime(_curr.year + 1),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            _checkInDate = selectedDate;
                          });
                          field.didChange(selectedDate);
                        }
                      },
                      child: InputDecorator(
                          decoration: InputDecoration(
                            labelText:
                                'Select the check-in date of your vehicle',
                            errorText: field.errorText,
                          ),
                          child: (_checkInDate != null)
                              ? Text('${_checkInDate!.toLocal()}')
                              : null));
                }),
            FormField<DateTime>(
                validator: FormHelpers.validateDate,
                builder: (FormFieldState<DateTime> field) {
                  return InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _checkOutDate ?? _curr,
                          firstDate: DateTime(_curr.year),
                          lastDate: DateTime(_curr.year + 1),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            _checkOutDate = selectedDate;
                          });
                          field.didChange(selectedDate);
                        }
                      },
                      child: InputDecorator(
                          decoration: InputDecoration(
                            labelText:
                                'Select the check-out date of your vehicle',
                            errorText: field.errorText,
                          ),
                          child: (_checkOutDate != null)
                              ? Text('${_checkOutDate!.toLocal()}')
                              : null));
                }),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    FirebaseFirestore.instance.collection("vehicles").add({
                      "make": _make,
                      "model": _model,
                      "year": _year,
                      "checkInDate": _checkInDate,
                      "checkOutDate": _checkOutDate,
                      "userId": FirebaseAuth.instance.currentUser?.uid,
                      "userDisplayName": _name
                    });
                    const successMsg = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Successfully added vehicle!"));
                    ScaffoldMessenger.of(context).showSnackBar(successMsg);
                    Navigator.of(context).pop();
                  } else {
                    const errorMsg = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Your form completed with errors."));
                    ScaffoldMessenger.of(context).showSnackBar(errorMsg);
                  }
                },
                child: const Text("Add"))
          ],
        ),
      ),
    );
  }
}
