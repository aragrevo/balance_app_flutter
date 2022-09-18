import 'package:balance_app/controllers/pocket.controller.dart';
import 'package:balance_app/models/pocket.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
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
              pocket.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const _Spacer(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Previous value'),
                Text(toCurrency(pocket.value)),
              ],
            ),
            const _Spacer(10),
            Obx(() => PocketController.to.isUpdating.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Update value'),
                      Text(PocketController.to.updateValue.value),
                    ],
                  )
                : const SizedBox()),
            const _Spacer(10),
            const Divider(),
            const _Spacer(10),
            TextFormField(
              controller: PocketController.to.titleController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Edit title',
                suffixIcon: Icon(Icons.title_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
              },
            ),
            const _Spacer(10),
            TextFormField(
              controller: PocketController.to.locationController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Edit location',
                suffixIcon: Icon(pocketIcons[pocket.location]),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
              },
            ),
            const _Spacer(10),
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
            const _Spacer(10),
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
                _OperationButton(
                  pocket: pocket,
                  operation: Operation.sum,
                ),
                const SizedBox(
                  width: 20,
                ),
                _OperationButton(
                  pocket: pocket,
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
            const _Spacer(10),
          ],
        ),
      ),
      // ),
    );
  }
}

class _Spacer extends StatelessWidget {
  const _Spacer(this.height);

  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class _OperationButton extends StatelessWidget {
  const _OperationButton({
    Key? key,
    required this.pocket,
    required this.operation,
  }) : super(key: key);

  final Pocket pocket;
  final Operation operation;

  @override
  Widget build(BuildContext context) {
    final bool isSum = operation == Operation.sum;
    return CircleAvatar(
      backgroundColor: isSum ? Colors.indigoAccent : Colors.orangeAccent,
      child: IconButton(
        icon: Icon(isSum ? Icons.add : Icons.remove),
        color: Colors.white,
        onPressed: () {
          PocketController.to.updatePocketValue(pocket, operation);
        },
      ),
    );
  }
}
