import 'package:findit_admin_app/containers/dashboard_text.dart';
import 'package:findit_admin_app/containers/home_btn.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
      ),
      body: Column(
        children: [
          Container(
            height: 240,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10,),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardText(keyword: "Total Orders", value: "120"),
                  DashboardText(keyword: "Total Products", value: "120"),
                  DashboardText(keyword: "Total Products", value: "120"),
                  DashboardText(keyword: "Total Products", value: "120"),
                  DashboardText(keyword: "Total Products", value: "120"),
                ],
              ),),
              Row(
                children: [
                  HomeBtn(onTap: (){}, name: "Orders",),
              HomeBtn(onTap: (){}, name: "Products",),
                ],
              ),
              Row(
                children: [
                  HomeBtn(onTap: (){}, name: "Promos",),
              HomeBtn(onTap: (){}, name: "Banners",),
                ],
              ),
              Row(
                children: [
                  HomeBtn(onTap: (){}, name: "Categories",),
              HomeBtn(onTap: (){}, name: "Coupons",),
                ],
              ),
        ],
      ),
    );
  }
}
