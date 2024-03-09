// import 'package:balance_app/controllers/category.controller.dart';
import 'package:balance_app/controllers/log.controller.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
// import 'package:balance_app/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LogsScreen extends StatelessWidget {
  LogsScreen({Key? key}) : super(key: key);
  static const String routeName = '/logs';
  final logCtrl = Get.put(LogController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text('Logs'),
          elevation: 0,
        ),
        body: const _Body());
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Column(
        children: [
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('Expenses'),
                    value: 'expense',
                    groupValue: LogController.to.type.value,
                    onChanged: (value) {
                      LogController.to.type.value = value.toString();
                      LogController.to.filterLogs();
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('Pockets'),
                    value: 'pocket',
                    groupValue: LogController.to.type.value,
                    onChanged: (value) {
                      LogController.to.type.value = value.toString();
                      LogController.to.filterLogs();
                    },
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () {
              if (LogController.to.logs.isEmpty) {
                return const Center(
                  child: Image(image: AssetImage('assets/images/empty.jpg')),
                );
              }
              return Expanded(
                  child: Obx(
                () => ListView.builder(
                  itemCount: LogController.to.logs.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, index) {
                    final log = LogController.to.logs[index];
                    final title = log.name.toCapitalize;
                    final icon = customIcons[title] ??
                        pocketIcons[log.location.toLowerCase()];
                    final subtitle = DateFormat()
                        .add_yMMMEd()
                        .format(DateTime.parse(log.date));
                    return Card(
                      elevation: 0,
                      color: const Color.fromRGBO(249, 249, 249, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                            child: icon != null
                                ? Icon(icon)
                                : Text(title.substring(0, 2).toUpperCase())),
                        title: Row(
                          children: [
                            Expanded(flex: 1, child: Text(title)),
                            Text(
                                NumberFormat.currency(
                                        locale: 'en_US',
                                        symbol: '💲',
                                        decimalDigits: 0)
                                    .format(log.value),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Expanded(child: Text(subtitle)),
                            Text(toCurrency(log.previousValue),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}

// class _Form extends StatelessWidget {
//   const _Form({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: CategoryController.to.formKey,
//       child: Column(
//         children: [
//           const Image(image: AssetImage('assets/images/bitcoin_transfer.png')),
//           DropdownButtonFormField(
//               decoration: const InputDecoration(labelText: 'Type'),
//               validator: (value) {
//                 if (value == null) {
//                   return 'Por favor seleccione un tipo';
//                 }
//                 return null;
//               },
//               items: const [
//                 DropdownMenuItem(
//                   child: Text('Expense'),
//                   value: 'expense',
//                 ),
//                 DropdownMenuItem(
//                   child: Text('Income'),
//                   value: 'revenue',
//                 ),
//               ],
//               onChanged: (value) {
//                 CategoryController.to.type.value = value as String;
//                 CategoryController.to.category.value = '';
//                 CategoryController.to.getCategories(value);
//               }),
//           const SizedBox(height: 20),
//           Obx(
//             () => DropdownButtonFormField(
//                 decoration: const InputDecoration(labelText: 'Category'),
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Por favor seleccione un tipo';
//                   }
//                   return null;
//                 },
//                 items: CategoryController.to.categories
//                     .map((category) => DropdownMenuItem(
//                           value: category['id'],
//                           child: Row(
//                             children: [
//                               Icon(
//                                 customIcons[category['id']
//                                         .toString()
//                                         .toCapitalize] ??
//                                     Icons.shopify_rounded,
//                                 color: ThemeColors.to.darkgray,
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Text(
//                                 category['name'],
//                               ),
//                             ],
//                           ),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   CategoryController.to.category.value = value as String;
//                 }),
//           ),
//           Obx(
//             () => (CategoryController.to.category.value == 'shop')
//                 ? Column(
//                     children: [
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         initialValue: CategoryController.to.observation.value,
//                         onChanged: (value) =>
//                             CategoryController.to.observation.value = value,
//                         keyboardType: TextInputType.text,
//                         decoration: const InputDecoration(
//                           labelText: 'Observation',
//                           suffixIcon: Icon(Icons.shopping_bag_rounded),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Por favor ingrese una observación';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   )
//                 : const SizedBox(),
//           ),
//           const SizedBox(height: 20),
//           Obx(
//             () => TextFormField(
//               initialValue: CategoryController.to.amount.value,
//               onChanged: (value) => CategoryController.to.amount.value = value,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Amount',
//                 suffixIcon: Icon(Icons.attach_money),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Por favor ingrese un monto';
//                 }
//                 return null;
//               },
//             ),
//           ),
//           const SizedBox(height: 20),
//           Hero(
//             tag: 'btn-home',
//             child: SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: Obx(
//                   () => ElevatedButton(
//                     onPressed: CategoryController.to.isSaving.value
//                         ? null
//                         : () async {
//                             if (!CategoryController.to.isValidForm()) return;
//                             await CategoryController.to.saveTransaction();
//                           },
//                     style: ElevatedButton.styleFrom(
//                         primary: Colors.yellow,
//                         onPrimary: Colors.black,
//                         shadowColor: Colors.yellowAccent,
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.0)),
//                         textStyle: const TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.w600)),
//                     child: CategoryController.to.isSaving.value
//                         ? const CircularProgressIndicator()
//                         : const Text('Add transaction'),
//                   ),
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }
