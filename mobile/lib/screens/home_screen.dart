import 'package:banboostore/services/user_api_service.dart';
import 'package:banboostore/utils/constants.dart';
import 'package:banboostore/pages/dashboard_admin_page.dart';
import 'package:banboostore/pages/profiles/profile_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/cart_page.dart';
import '../pages/home_page.dart';

class HomePageWithBottomBar extends StatefulWidget {
  const HomePageWithBottomBar({super.key});

  @override
  _HomePageWithBottomBarState createState() => _HomePageWithBottomBarState();
}

class _HomePageWithBottomBarState extends State<HomePageWithBottomBar> with TickerProviderStateMixin {
  late TabController _tabController;
  String _userRole = "customer";

  @override
  void initState() {
    super.initState();
    getUserRole();
    _tabController = TabController(length: _userRole == "admin" ? 2 : 3, vsync: this);

  }

  Future<void> getUserRole() async {
    _userRole = (await UserApiService.getUserRole())!;
    setState(() {
      _tabController = TabController(length: _userRole == "admin" ? 2 : 3, vsync: this);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = _userRole == "admin"
        ? [DashboardAdminPage(), ProfilePage()]
        : [ HomePage(), CartPage(), ProfilePage()
    ];

    return Scaffold(
      body: BottomBar(
        fit: StackFit.expand,
        icon: (width, height) => Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(
              Icons.arrow_upward_rounded,
              color: Colors.white,
              size: width,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
        showIcon: true,
        width: MediaQuery.of(context).size.width * 0.8,
        barColor: AppColors.backgroundDarkColor, // Color of the bottom bar
        start: 2,
        end: 0,
        offset: 10,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 35,
        iconWidth: 35,
        reverse: false,
        hideOnScroll: true,
        scrollOpposite: false,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
          controller: _tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          children: _pages, // Display page based on selected tab
        ),
        child: TabBar(
          controller: _tabController,
          indicatorColor:AppColors.secondaryColor,
          indicatorPadding: const EdgeInsets.only(bottom: 6),
          labelColor: AppColors.secondaryColor, // Active tab text color
          unselectedLabelColor: Colors.white, // Inactive tab text color
          tabs: _userRole == "admin"
          ? [
            const SizedBox(
                height: 55,
                width: 40,
                child: Center(child: Icon(FontAwesomeIcons.idCard))
            ),
            const SizedBox(
                height: 55,
                width: 40,
                child: Center(child: Icon(FontAwesomeIcons.user))
            ),
          ] : [
            const SizedBox(
              height: 55,
                width: 40,
                child:  Center(child: Icon(FontAwesomeIcons.home))
            ),
            SizedBox(
                height: 55,
                width: 40,
                child: _userRole == "admin" ? const Center(child: Icon(FontAwesomeIcons.idCard)) : const Center(child: Icon(FontAwesomeIcons.shoppingCart))
            ),
            const SizedBox(
                height: 55,
                width: 40,
                child: Center(child: Icon(FontAwesomeIcons.user))
            ),
          ],
        ),
      ),
    );
  }


}
