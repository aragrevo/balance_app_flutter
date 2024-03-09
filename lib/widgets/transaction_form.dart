import 'package:balance_app/controllers/category.controller.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
import 'package:balance_app/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionForm extends StatelessWidget {
  const TransactionForm({
    Key? key,
    this.id,
  }) : super(key: key);

  final String? id;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: CategoryController.to.formKey,
      child: Column(
        children: [
          _TypeField(isEditing: id != null),
          const SizedBox(height: 20),
          Obx(
            () => DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                value: id != null ? CategoryController.to.category.value : null,
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione un tipo';
                  }
                  return null;
                },
                items: CategoryController.to.categories
                    .map((category) => DropdownMenuItem(
                          value: category['id'],
                          child: Row(
                            children: [
                              Icon(
                                customIcons[category['id']
                                        .toString()
                                        .toCapitalize] ??
                                    Icons.shopify_rounded,
                                color: ThemeColors.to.darkgray,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                category['name'],
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  CategoryController.to.category.value = value as String;
                }),
          ),
          Obx(
            () => (CategoryController.to.category.value == 'shop')
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: CategoryController.to.observation.value,
                        onChanged: (value) =>
                            CategoryController.to.observation.value = value,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Observation',
                          suffixIcon: Icon(Icons.shopping_bag_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese una observación';
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          const SizedBox(height: 20),
          Obx(
            () => TextFormField(
              initialValue: CategoryController.to.amount.value,
              onChanged: (value) => CategoryController.to.amount.value = value,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                suffixIcon: Icon(Icons.attach_money),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un monto';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              final now = DateTime.now();
              final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: DateTime(now.year, now.month),
                  lastDate: now);
              if (picked != null) {
                CategoryController.to.date.value = picked;
                CategoryController.to.dateCtrl.text = picked.formatDate;
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: CategoryController.to.dateCtrl,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Enter Date',
                  suffixIcon: Icon(Icons.date_range_rounded),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Hero(
            tag: 'btn-home',
            child: SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: CategoryController.to.isSaving.value
                        ? null
                        : () async {
                            if (!CategoryController.to.isValidForm()) return;
                            id != null
                                ? await CategoryController.to
                                    .updateTransaction(id!)
                                : await CategoryController.to.saveTransaction();
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        shadowColor: Colors.yellowAccent,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    child: CategoryController.to.isSaving.value
                        ? const CircularProgressIndicator()
                        : Text(id != null ? 'Update' : 'Add transaction'),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class _TypeField extends StatelessWidget {
  const _TypeField({
    Key? key,
    required this.isEditing,
  }) : super(key: key);

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Obx(
        () => TextFormField(
          initialValue: CategoryController.to.type.value.toCapitalize,
          keyboardType: TextInputType.text,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Type',
            suffixIcon: Icon(Icons.move_down_rounded),
          ),
        ),
      );
    }
    return DropdownButtonFormField(
        decoration: const InputDecoration(labelText: 'Type'),
        validator: (value) {
          if (value == null) {
            return 'Por favor seleccione un tipo';
          }
          return null;
        },
        items: const [
          DropdownMenuItem(
            value: 'expense',
            child: Text('Expense'),
          ),
          DropdownMenuItem(
            value: 'revenue',
            child: Text('Income'),
          ),
        ],
        onChanged: (value) {
          CategoryController.to.type.value = value as String;
          CategoryController.to.category.value = '';
          CategoryController.to.getCategories(value);
        });
  }
}
