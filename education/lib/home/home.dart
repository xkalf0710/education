import 'package:flutter/material.dart';
import 'package:education/utils/app_colors.dart' as AppColors;
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ImageIcon(AssetImage("img/menu.jpg"), size: 24, color: Colors.black,),
                    Row(children: [
                      Icon(Icons.search),
                      SizedBox(width: 10,),
                      Icon(Icons.notification_add),
                    ],
                    ),
                  ],
                ),
              ),
              Row(),
            ],
          ),
        ),
      ),
    );
  }
}
