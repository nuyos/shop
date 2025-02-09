import 'package:flutter/material.dart';
import 'package:shop_admin/item_add_page.dart';
import 'package:shop_admin/item_view_page.dart';
import 'package:shop_admin/order_list_page.dart';


class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.add_circle_outline),
            icon: Icon(Icons.add_circle_outline_outlined),
            label: 'item add',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.list_alt),
            icon: Icon(Icons.list_alt_outlined),
            label: 'item list',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.people_alt),
            icon: Icon(Icons.people_alt_outlined),
            label: 'order list',
          ),
        ],
      ),
      body: <Widget>[
        ItemAddPage(),

        ItemViewPage(),

        OrderListPage(),
      ][currentPageIndex],
    );
  }
}
