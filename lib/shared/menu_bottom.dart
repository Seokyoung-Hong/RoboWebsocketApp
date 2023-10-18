import 'package:flutter/material.dart';

class MenuBottom extends StatelessWidget {
  const MenuBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/WebServerMod');
            break;
          case 1:
            Navigator.pushNamed(context, '/LocalMod');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.traffic),
          label: 'WebServerMod',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_in_ar),
          label: 'LocalMod',
        ),
      ],
    );
  }
}
