import 'package:budget_tracker/Screens/category_dropdown.dart';
import 'package:budget_tracker/utils/appValidator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Budget Tracker"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text("Press the + button to add a transaction"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTransactionDialog(context);
        },
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.add),
      ),
    );
  }
}

void showAddTransactionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.blue.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: const AddTransactionForm(),
        ),
      );
    },
  );
}

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  String type = "credit";
  String category = "others";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoader = false;
  final appvalidator = Appvalidator();
  final amountEditController = TextEditingController();
  final titleEditController = TextEditingController();
  final uid = Uuid();

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoader = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Error: User not logged in");
        return;
      }

      String userId = user.uid;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      int amount = int.parse(amountEditController.text);
      DateTime date = DateTime.now();
      String id = uid.v4();
      String monthyear = DateFormat('MMM y').format(date);

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        print("Error: User document does not exist");
        return;
      }

      int remainingAmount = userDoc['remainingAmount'];
      int totalCredit = userDoc['totalCredit'];
      int totalDebit = userDoc['totalDebit'];

      if (type == 'credit') {
        remainingAmount += amount;
        totalCredit += amount;
      } else {
        remainingAmount -= amount;
        totalDebit += amount;
      }

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        "remainingAmount": remainingAmount,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "updatedAt": timestamp,
      });

      var data = {
        "id": id,
        "title": titleEditController.text,
        "amount": amount,
        "type": type,
        "timestamp": timestamp,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "remainingAmount": remainingAmount,
        "monthyear": monthyear,
        "category": category,
      };

      print("Saving transaction to: users/$userId/transactions/$id");

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("transactions")
          .doc(id)
          .set(data);

      print("Transaction added successfully");
      Navigator.pop(context); // Close the dialog
    } catch (error) {
      print("Error adding transaction: $error");
    } finally {
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
              controller: titleEditController,
              validator: appvalidator.isEmptyCheck,
              decoration: InputDecoration(
                labelText: 'Title',
                focusColor: Colors.blue.shade50,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appvalidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 12),
            CategoryDropDown(
              cattype: category,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: type,
              items: const [
                DropdownMenuItem(value: 'credit', child: Text('Credit')),
                DropdownMenuItem(value: 'debit', child: Text('Debit')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    type = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoader ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.blue.shade100),
                ),
              ),
              child: isLoader
                  ? const Center(child: CircularProgressIndicator())
                  : Text("Add Transaction", style: TextStyle(color: Colors.blue.shade900)),
            ),
          ],
        ),
      ),
    );
  }
}
