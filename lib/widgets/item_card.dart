import 'package:balance_app/models/expense.dart';
import 'package:balance_app/services/expenses.service.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatelessWidget {
  final Expense item;
  const ItemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = item.observation ?? item.description;
    final subtitle =
        DateFormat().add_yMMMEd().format(DateTime.parse(item.date));
    return Card(
      elevation: 0,
      color: const Color.fromRGBO(249, 249, 249, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
            child: customIcons[title] != null
                ? Icon(customIcons[title])
                : Text(title.substring(0, 2).toUpperCase())),
        title: Row(
          children: [
            Expanded(child: Text(title.toCapitalize), flex: 1),
            Text(
                NumberFormat.currency(
                        locale: 'en_US', symbol: '💲', decimalDigits: 0)
                    .format(item.cost),
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        subtitle: Text(subtitle),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                WidgetsBinding.instance?.addPostFrameCallback((_) async {
                  Get.bottomSheet(
                      Container(
                        height: Get.height / 1.7,
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))));
                });
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.edit_rounded,
                    color: Colors.indigoAccent,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () async {
                WidgetsBinding.instance?.addPostFrameCallback((_) async {
                  Get.defaultDialog(middleText: 'Are you sure?', actions: [
                    ElevatedButton(
                        onPressed: () {
                          ExpensesService().deleteExpense(item.id!, item);
                        },
                        child: const Text('Yes, I am'))
                  ]);
                });
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.delete_rounded,
                    color: Colors.redAccent,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
