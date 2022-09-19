import 'package:balance_app/controllers/pocket.controller.dart';
import 'package:balance_app/models/pocket.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
import 'package:balance_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PocketForm extends StatelessWidget {
  const PocketForm({
    Key? key,
    required this.pocket,
  }) : super(key: key);

  final Pocket pocket;

  @override
  Widget build(BuildContext context) {
    PocketController.to.restOfBalance.value = pocket.restOfBalance;
    PocketController.to.titleController.text = pocket.name;
    PocketController.to.locationController.text = pocket.location;
    return Container(
      padding: const EdgeInsets.all(16),
      height: Get.height / 1.7,
      child: Form(
        key: PocketController.to.formKey,
        child: Column(
          children: [
            Text(
              pocket.name.isEmpty ? 'New pocket' : pocket.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const CustomSpacer(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Previous value'),
                Text(toCurrency(pocket.value)),
              ],
            ),
            const CustomSpacer(10),
            Obx(() => PocketController.to.isUpdating.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Update value'),
                      Text(toCurrency(PocketController.to.updateValue.value)),
                    ],
                  )
                : const SizedBox()),
            const CustomSpacer(10),
            const Divider(),
            const CustomSpacer(10),
            TextFormField(
              controller: PocketController.to.titleController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Title',
                suffixIcon: Icon(Icons.title_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
              },
            ),
            const CustomSpacer(10),
            TextFormField(
              controller: PocketController.to.locationController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Location',
                suffixIcon: Icon(pocketIcons[pocket.location]),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
              },
            ),
            const CustomSpacer(10),
            Obx(() => TextFormField(
                  initialValue: PocketController.to.newValue.value,
                  onChanged: (value) =>
                      PocketController.to.newValue.value = value,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'New value',
                    suffixIcon: Icon(Icons.attach_money),
                  ),
                )),
            const CustomSpacer(10),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Rest of balance? : '),
                Obx(() {
                  return Switch(
                    value: PocketController.to.restOfBalance.value,
                    onChanged: (value) {
                      PocketController.to.restOfBalance.value = value;
                    },
                  );
                }),
                const Expanded(child: SizedBox()),
                OperationButton(
                  onPressed: () => PocketController.to
                      .updatePocketValue(pocket, Operation.sum),
                  operation: Operation.sum,
                ),
                const SizedBox(
                  width: 20,
                ),
                OperationButton(
                  onPressed: () => PocketController.to
                      .updatePocketValue(pocket, Operation.rest),
                  operation: Operation.rest,
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            ElevatedButton(
              onPressed: () {
                if (PocketController.to.isValidForm()) {
                  PocketController.to.savePocket(pocket);
                }
              },
              child: const Text('Save'),
            ),
            const CustomSpacer(10),
          ],
        ),
      ),
      // ),
    );
  }
}
