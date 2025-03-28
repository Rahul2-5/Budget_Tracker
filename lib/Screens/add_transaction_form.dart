import 'package:budget_tracker/Screens/category_dropdown.dart';
import 'package:budget_tracker/utils/appValidator.dart';
import 'package:flutter/material.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  var type = "credit";
  var category = "others";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appvalidator = Appvalidator();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoader = true);

      setState(() => isLoader = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appvalidator.isEmptyCheck,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appvalidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            CategoryDropDown(
              cattype: category,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    type = value;
                  });
                }
              },
            ),
            DropdownButtonFormField(
                value: 'credit',
                items: [
                  DropdownMenuItem(
                    child: Text('Credit'),
                    value: 'credit',
                  ),
                  DropdownMenuItem(
                    child: Text('Debit'),
                    value: 'debit',
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      type = value;
                    });
                  }
                }),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () {
                  if (isLoader == false) {
                    _submitForm();
                  }
                },
                child: isLoader ? Center(child: CircularProgressIndicator()) :
                Text("Add Transaction")),
          ],
        ),
      ),
    );
  }
}
