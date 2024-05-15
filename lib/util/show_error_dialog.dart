

import 'package:flutter/widgets.dart';
import 'package:mynotes/util/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text
){
  return showGenericDialog(
    context: context,
    title: 'An error occured',
    content: text,
    optionBuilder: () =>{
      'OK':null
    },
  );
}