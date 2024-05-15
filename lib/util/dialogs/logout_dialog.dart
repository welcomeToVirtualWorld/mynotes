import 'package:flutter/widgets.dart';
import 'package:mynotes/util/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context){
  return showGenericDialog(
    context: context,
    title: 'Delete',
    content: 'Are you sure want to delete this item?',
    optionBuilder: () =>{
      'Cancel':false,
      'Yes': true,
    },
  ).then((value) => value?? false);
}