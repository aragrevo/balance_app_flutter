import 'package:balance_app/models/expense.dart';
import 'package:balance_app/services/balance.service.dart';
import 'package:balance_app/services/expenses.service.dart';
import 'package:balance_app/services/services.dart';
import 'package:balance_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final balanceSvc = Provider.of<BalanceService>(context);

    return Scaffold(
        appBar: AppBar(
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
          onPressed: () {},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
          elevation: 2,
          backgroundColor: Colors.yellow[600],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: const _Body());
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final expensesSvc = Provider.of<ExpensesService>(context);
    return Container(
      color: const Color(0X0B0D10),
      // padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Summary(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: _ExpensesList(
                expensesList: expensesSvc.expensesList,
              ),
            ),
          ),
        ],
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
    return Container(
      height: 250,
      width: double.infinity,
      child: const Text(
        'My wallet',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ExpensesList extends StatelessWidget {
  const _ExpensesList({
    Key? key,
    required this.expensesList,
  }) : super(key: key);

  final List<Expense> expensesList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent expenses',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: expensesList.length,
              itemBuilder: (_, int index) {
                final item = expensesList[index];
                return ItemCard(
                    amount: item.cost,
                    title: item.description,
                    subtitle: DateFormat()
                        .add_yMMMEd()
                        .format(DateTime.parse(item.date)));
              }),
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
    print(authSvc.user?.photoUrl);
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
