import 'package:balance_app/controllers/category.controller.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
import 'package:balance_app/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({Key? key}) : super(key: key);
  static const String routeName = '/transaction';
  final categoryCtrl = Get.put(CategoryController());
  @override
  Widget build(BuildContext context) {
    return const _Body();
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Transaction'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: const _Form(),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: CategoryController.to.formKey,
      child: Column(
        children: [
          const Image(image: AssetImage('assets/images/bitcoin_transfer.png')),
          DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Type'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor seleccione un tipo';
                }
              },
              items: const [
                DropdownMenuItem(
                  child: Text('Expense'),
                  value: 'expense',
                ),
                DropdownMenuItem(
                  child: Text('Income'),
                  value: 'revenue',
                ),
              ],
              onChanged: (value) {
                CategoryController.to.type.value = value as String;
                CategoryController.to.category.value = '';
                CategoryController.to.getCategories(value);
              }),
          const SizedBox(height: 20),
          Obx(
            () => DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione un tipo';
                  }
                },
                items: CategoryController.to.categories
                    .map((category) => DropdownMenuItem(
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
                          value: category['id'],
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
              },
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
                            await CategoryController.to.saveTransaction();
                          },
                    child: CategoryController.to.isSaving.value
                        ? const CircularProgressIndicator()
                        : const Text('Add transaction'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.yellow,
                        onPrimary: Colors.black,
                        shadowColor: Colors.yellowAccent,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
