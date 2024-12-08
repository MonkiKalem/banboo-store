import 'package:banboostore/constants.dart';
import 'package:banboostore/pages/cart_page.dart';
import 'package:banboostore/pages/profile_page.dart';
import 'package:banboostore/screens/onboarding_screen.dart';
import 'package:banboostore/services/api_service.dart';
import 'package:banboostore/widgets/banboo_card.dart';
import 'package:banboostore/widgets/layout/carousel.dart';
import 'package:banboostore/widgets/layout/item_card_layout_grid.dart';
import 'package:banboostore/widgets/layout/item_card_layout_staggered_grid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../model/banboo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// https://fastcdn.hoyoverse.com/content-v2/nap/114225/608830bc6382b73079821aed7b19fda8_8240430244310614598.jpg

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    HomePage(), // Page for Home
    CartPage(), // Page for Cart
    ProfilePage(), // Page for Profile
  ];

  final List<String> imgList = [
    'https://upload-os-bbs.hoyolab.com/upload/2023/11/14/369285726/28dc5c0e5c42688897d715128fa56f6f_2636221330479257776.jpg?x-oss-process=image%2Fresize%2Cs_1000%2Fauto-orient%2C0%2Finterlace%2C1%2Fformat%2Cwebp%2Fquality%2Cq_70',
    'https://upload-os-bbs.hoyolab.com/upload/2023/11/14/369285726/8fe0f2b73ade440b14e9d03f85b65737_8292970554535359034.jpg?x-oss-process=image%2Fresize%2Cs_1000%2Fauto-orient%2C0%2Finterlace%2C1%2Fformat%2Cwebp%2Fquality%2Cq_70',
    'https://upload-os-bbs.hoyolab.com/upload/2023/11/15/369285726/269eeb2766426c210e356a04bf927a69_4370142326493041399.jpg?x-oss-process=image%2Fresize%2Cs_1000%2Fauto-orient%2C0%2Finterlace%2C1%2Fformat%2Cwebp%2Fquality%2Cq_70',
    'https://upload-os-bbs.hoyolab.com/upload/2024/07/14/369285726/50a1512638206da7680d2db0924f136f_478926785863762848.png?x-oss-process=image%2Fresize%2Cs_1000%2Fauto-orient%2C0%2Finterlace%2C1%2Fformat%2Cwebp%2Fquality%2Cq_70',
    'https://upload-os-bbs.hoyolab.com/upload/2024/07/16/369285726/355f02a46b33e37ab95ff37165924889_862749925127952124.png?x-oss-process=image%2Fresize%2Cs_1000%2Fauto-orient%2C0%2Finterlace%2C1%2Fformat%2Cwebp%2Fquality%2Cq_70',
  ];

  List<Banboo> banbooList = [
    Banboo(
      banbooId: "001",
      imageUrl: "https://rerollcdn.com/ZZZ/Bangboo/1/amillion.png",
      name: "Amillion",
      level: "2",
      description: "ehehehehe",
      elementId: "pyro",
      price: 14500,
    ),
    Banboo(
      banbooId: "001",
      imageUrl: "https://rerollcdn.com/ZZZ/Bangboo/1/amillion.png",
      name: "Amillion",
      level: "2",
      description: "ehehehehe",
      elementId: "pyro",
      price: 14500,
    ),
    Banboo(
      banbooId: "001",
      imageUrl: "https://rerollcdn.com/ZZZ/Bangboo/1/amillion.png",
      name: "Amillion",
      level: "2",
      description: "ehehehehe",
      elementId: "pyro",
      price: 14500,
    ),
    Banboo(
      banbooId: "001",
      imageUrl: "https://rerollcdn.com/ZZZ/Bangboo/1/amillion.png",
      name: "Amillion",
      level: "2",
      description: "ehehehehe",
      elementId: "pyro",
      price: 14500,
    ),
    Banboo(
      banbooId: '002',
      name: 'Butler',
      price: 15000,
      description: 'Another Banboo dollawdaawdawaw',
      elementId: 'Dark',
      level: '4',
      imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/butler.png',
    ),
    Banboo(
      banbooId: '003',
      name: 'Sharkboo',
      price: 150.0,
      description: 'Another Banboo doll',
      elementId: 'B002',
      level: '6',
      imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/sharkboo.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGreyColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 300.0,
                collapsedHeight: 70,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.backgroundDarkColor,
                leading: IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {},
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await ApiService.logout();
                      Navigator.pushReplacementNamed(context, "/onboarding");
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: const Text("Banboo Store",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                  background: Stack(children: [
                    SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://upload-os-bbs.hoyolab.com/upload/2023/11/15/369285726/fe6f361715d2e479c9333aa4eb56debd_5228699759752292298.jpg?x-oss-process=image%2Fresize%2Cs_1000%2Fauto-orient%2C0%2Finterlace%2C1%2Fformat%2Cwebp%2Fquality%2Cq_70",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ]),
                )),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              // caraousel images
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: AppColors.secondaryColor,
                child: Carousel(),
              ),
              const Text("Banboo List",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ItemCardLayoutStaggeredGrid(
                    crossAxisCount: 2, banboos: banbooList),
              ),
              Container(
                height: 64,
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: const Text("Banboo Store"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
