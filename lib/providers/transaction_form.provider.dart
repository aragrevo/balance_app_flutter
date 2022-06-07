import 'package:flutter/material.dart';

class TransactionFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  dynamic document = {
    'type': '',
    'category': '',
    'amount': '',
  };

  TransactionFormProvider();

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
