import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/controllers/category.controller.dart';
import 'package:balance_app/controllers/expense.controller.dart';
import 'package:balance_app/controllers/home.controller.dart';
import 'package:balance_app/models/balance_detail.dart';
import 'package:balance_app/models/expense.dart';
import 'package:balance_app/screens/screens.dart';
import 'package:balance_app/screens/transaction_screen.dart';
import 'package:balance_app/services/services.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/widgets/fade_indexed_stack.dart';
import 'package:balance_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// TODO: Search functionality

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final authSvc = Provider.of<AuthService>(context, listen: false);
    if (authSvc.user?.id == null) return const SizedBox();
    return _Home();
  }
}

class _Home extends StatelessWidget {
  _Home({
    Key? key,
  }) : super(key: key);

  final homeCtrl = Get.put(HomeController());
  final expCtrl = Get.put(ExpenseController());
  final balCtrl = Get.put(BalanceController());
  final categoryCtrl = Get.put(CategoryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: HomeController.to.scaffoldKey,
        extendBody: true,
        appBar: AppBar(
            backgroundColor: const Color(0xff2c4260),
            titleTextStyle: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            elevation: 0,
            leading: const _Avatar(),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await AuthService().signOut();
                  Get.offNamedUntil(SigninScreen.routeName, (route) => false);
                },
              )
            ],
            title: const Text('Balance App')),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btn-home',
          onPressed: () async {
            CategoryController.to.resetForm();
            BalanceController.to.balance != null
                ? Get.toNamed(TransactionScreen.routeName)
                : BalanceController.to.createBalance();
          },
          tooltip: 'Increment',
          elevation: 2,
          backgroundColor: Colors.yellow[600],
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const CustomBottomNavigationBar(),
        endDrawer: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.redAccent),
            child: const SettingsDrawer()),
        endDrawerEnableOpenDragGesture: false,
        body: Obx(() {
          return FadeIndexedStack(
              index: HomeController.to.currentIndex.value,
              children: [
                const _Body(),
                PocketScreen(),
                const ChartScreen(),
              ]);
        }));
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff2c4260),
      child: Stack(
        children: [
          const _Summary(),
          GetX<BalanceController>(
            init: Get.put<BalanceController>(BalanceController()),
            builder: (BalanceController ctrl) {
              return _BalanceCard(balance: ctrl.balance?.balance);
            },
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.75,
              maxChildSize: 1,
              snap: true,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: GetX<ExpenseController>(
                    init: Get.put<ExpenseController>(ExpenseController()),
                    builder: (ExpenseController ctrl) {
                      return _ExpensesList(
                          scrollController: scrollController,
                          expensesList: ctrl.expensesList,
                          onRefresh: () async {});
                    },
                  ),
                );
              }),
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

  final BalanceDetail? balance;

  @override
  Widget build(BuildContext context) {
    final authSvc = Provider.of<AuthService>(context, listen: false);
    final value = authSvc.money == Money.eur ? balance?.euro : balance?.value;
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
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
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
              Text(toCurrency(value, money: authSvc.money),
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
    final authSvc = Provider.of<AuthService>(context, listen: false);
    final money = authSvc.money;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xff2c4260),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
        ),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My wallet',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final revenue = BalanceController.to.balance?.revenue;
                final amount = authSvc.isEuro ? revenue?.euro : revenue?.value;
                return Expanded(
                    child: _Item(
                  money: money,
                  title: 'Income',
                  amount: amount ?? 0,
                ));
              }),
              Obx(() {
                final expense = BalanceController.to.balance?.expense;
                final amount = authSvc.isEuro ? expense?.euro : expense?.value;
                return Expanded(
                    child: _Item(
                  money: money,
                  title: 'Expenses',
                  amount: amount ?? 0,
                ));
              }),
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
    required this.money,
  }) : super(key: key);

  final String title;
  final double amount;
  final Money? money;

  @override
  Widget build(BuildContext context) {
    // final symbol = money == Money.eur ? '€ ' : '\$ ';
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
                toCurrency(amount, money: money),
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
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;
  final List<Expense> expensesList;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    var queryExpensesList = expensesList.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Expanded(
                  child: (HomeController.to.searching.value == false)
                      ? const Text(
                          'Recent expenses',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      : TextFormField(
                          initialValue: '',
                          onChanged: (value) {
                            final query = value.toLowerCase();
                            queryExpensesList.value = expensesList
                                .where((element) => element.description
                                    .toLowerCase()
                                    .contains(query))
                                .toList();
                          },
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Search',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12)),
                        ))),
              IconButton(
                  onPressed: () {
                    HomeController.to.searching.value =
                        !HomeController.to.searching.value;
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
        ),
        Expanded(
          child: Obx(() => RefreshIndicator(
                onRefresh: onRefresh,
                child: queryExpensesList.isEmpty
                    ? const Hero(
                        tag: 'bitcoin-image',
                        child: Image(
                            image: AssetImage(
                                'assets/images/bitcoin_transfer.png')),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: queryExpensesList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, int index) {
                          final item = queryExpensesList[index];
                          return ItemCard(
                            item: item,
                          );
                        }),
              )),
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
