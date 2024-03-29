import 'package:balance_app/controllers/category.controller.dart';
import 'package:balance_app/models/expense.dart';
import 'package:balance_app/services/auth_service.dart';
import 'package:balance_app/services/expenses.service.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
import 'package:balance_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final Expense item;
  const ItemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authSvc = Provider.of<AuthService>(context, listen: false);

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
            Expanded(flex: 1, child: Text(title.toCapitalize)),
            Text(toCurrency(item.cost, money: authSvc.money),
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        subtitle: Text(subtitle),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                CategoryController.to.type.value = 'expense';
                CategoryController.to.getCategories('expense');
                var categoryId = title.toLowerCase();
                final categoryMap = CategoryController.to.categories
                    .firstWhereOrNull((element) => element['id'] == categoryId);
                if (categoryMap == null) {
                  categoryId = 'shop';
                  CategoryController.to.observation.value = title;
                }
                CategoryController.to.category.value = categoryId;
                CategoryController.to.amount.value = item.cost.toString();
                CategoryController.to.previousAmount.value =
                    item.cost.toString();
                CategoryController.to.date.value = DateTime.parse(item.date);
                CategoryController.to.dateCtrl.text =
                    DateTime.parse(item.date).formatDate;
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  Get.bottomSheet(
                      Container(
                        height: Get.height / 1.65,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'Edit Transaction',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const CustomSpacer(16),
                            TransactionForm(
                              id: item.id,
                            ),
                          ],
                        ),
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))));
                });
              },
              child: const Row(
                children: [
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
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  Get.defaultDialog(middleText: 'Are you sure?', actions: [
                    ElevatedButton(
                        onPressed: () async {
                          await ExpensesService().deleteExpense(item.id!, item);
                          Get.back();
                        },
                        child: const Text('Yes, I am'))
                  ]);
                });
              },
              child: const Row(
                children: [
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
