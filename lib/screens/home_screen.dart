import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/controllers/expense.controller.dart';
import 'package:balance_app/controllers/home.controller.dart';
import 'package:balance_app/models/expense.dart';
import 'package:balance_app/screens/screens.dart';
import 'package:balance_app/screens/transaction_screen.dart';
import 'package:balance_app/services/services.dart';
import 'package:balance_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final homeCtrl = Get.put(HomeController());

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return const _Home();
  }
}

class _Home extends StatelessWidget {
  const _Home({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
            backgroundColor: Colors.black87,
            titleTextStyle: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            elevation: 0,
            leading: const _Avatar(),
            title: const Text('Balance App'),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.notifications_none),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.menu_outlined),
              ),
            ]),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btn-home',
          onPressed: () async {
            Get.toNamed(TransactionScreen.routeName);
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
          elevation: 2,
          backgroundColor: Colors.yellow[600],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: Obx(
          () => IndexedStack(
            index: HomeController.to.currentIndex.value,
            children: [_Body(), const SizedBox(), const ChartScreen()],
          ),
        ));
  }
}

class _Body extends StatelessWidget {
  _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (balanceCtrl.balance.isEmpty) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return Container(
      color: Colors.black87,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(color: Colors.white, child: const _Summary()),
              Expanded(
                child: Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: GetX<ExpenseController>(
                      init: Get.put<ExpenseController>(ExpenseController()),
                      builder: (ExpenseController ctrl) {
                        return _ExpensesList(
                            expensesList: ctrl.expensesList,
                            onRefresh: () async {});
                      },
                    )),
              ),
            ],
          ),
          GetX<BalanceController>(
            init: Get.put<BalanceController>(BalanceController()),
            builder: (BalanceController ctrl) {
              return _BalanceCard(balance: ctrl.balance['balance']);
            },
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    Key? key,
    required this.balance,
  }) : super(key: key);

  final balance;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 30,
      right: 30,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1,
            ),
          ],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Total Balance',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w600)),
              const SizedBox(width: 10),
              Text(
                  NumberFormat.currency(
                          locale: 'en_US', symbol: '\$ ', decimalDigits: 0)
                      .format(balance?['value'] ?? 0),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (income == null || expenses == null) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
        ),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My wallet',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Expanded(
                    child: _Item(
                  title: 'Income',
                  amount:
                      BalanceController.to.balance['revenue']?['value'] ?? 0,
                )),
              ),
              Obx(
                () => Expanded(
                    child: _Item(
                  title: 'Expenses',
                  amount:
                      BalanceController.to.balance['expense']?['value'] ?? 0,
                )),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    Key? key,
    required this.title,
    required this.amount,
  }) : super(key: key);

  final String title;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: title == 'Expenses'
                ? const Icon(
                    Icons.arrow_circle_down_outlined,
                    color: Colors.white70,
                    size: 28,
                  )
                : const Icon(
                    Icons.arrow_circle_up_outlined,
                    color: Colors.white70,
                    size: 28,
                  )),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                NumberFormat.currency(
                        locale: 'en_US', symbol: '\$ ', decimalDigits: 0)
                    .format(amount),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpensesList extends StatelessWidget {
  const _ExpensesList({
    Key? key,
    required this.expensesList,
    required this.onRefresh,
  }) : super(key: key);

  final List<Expense> expensesList;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            'Recent expenses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: expensesList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: expensesList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_, int index) {
                      final item = expensesList[index];
                      final txt = item.observation ?? item.description;
                      return ItemCard(
                          amount: item.cost,
                          title: txt,
                          subtitle: DateFormat()
                              .add_yMMMEd()
                              .format(DateTime.parse(item.date)));
                    }),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authSvc = Provider.of<AuthService>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: authSvc.user?.photoUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(authSvc.user!.photoUrl!),
            )
          : const Icon(Icons.account_circle_rounded),
    );
  }
}
