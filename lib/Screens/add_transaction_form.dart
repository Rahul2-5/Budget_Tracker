import 'package:budget_tracker/Screens/category_dropdown.dart';
import 'package:budget_tracker/utils/appValidator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

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
    int amount;

    try {
      amount = int.parse(amountEditController.text);
      if(amount <= 0){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Amount must be greater than 0")),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid number")),
      );
      return;
    }

    DateTime date = DateTime.now();
    String id = uid.v4();
    String monthyear = DateFormat('MMM y').format(date);

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final userDoc = await userDocRef.get();

    //  Use null-aware default values in case fields are missing
    final data = userDoc.data() ?? {};
    int remainingAmount = data['remainingAmount'] ?? 0;
    int totalCredit = data['totalCredit'] ?? 0;
    int totalDebit = data['totalDebit'] ?? 0;

    if (!userDoc.exists) {
      await userDocRef.set({
        "name": user.displayName ?? '',
        "email": user.email ?? '',
        "photoUrl": user.photoURL ?? '',
        "provider": user.providerData.isNotEmpty ? user.providerData[0].providerId : 'google',
        "createdAt": DateTime.now().toIso8601String(),
        "remainingAmount": remainingAmount,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "updatedAt": timestamp,
      });
    }

    if (type == 'credit') {
      remainingAmount += amount;
      totalCredit += amount;
    } else {
      remainingAmount -= amount;
      totalDebit += amount;
    }

    await userDocRef.update({
      "remainingAmount": remainingAmount,
      "totalCredit": totalCredit,
      "totalDebit": totalDebit,
      "updatedAt": timestamp,
    });

    var transactionData = {
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
      "date": date.toIso8601String(),

      // Optional user info
      "name": user.displayName ?? '',
      "email": user.email ?? '',
      "photoUrl": user.photoURL ?? '',
      "provider": user.providerData.isNotEmpty ? user.providerData[0].providerId : 'google',
    };

    await userDocRef.collection("transactions").doc(id).set(transactionData);

    print("Transaction added successfully");
    Navigator.pop(context); // Close the dialog
  } catch (error) {
    print("Error adding transaction: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${error.toString()}")),
    );
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
