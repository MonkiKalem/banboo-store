import 'package:banboostore/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../services/user_api_service.dart';
import '../widgets/layout/carousel.dart';
import '../widgets/layout/item_card_layout_staggered_grid.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  get banbooList => null;

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
                      await UserApiService.logout();
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
              Stack(children: [
                Container(
                  height: 220,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.backgroundColor,
                        AppColors.backgroundGreyColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

              Container(
                height: 64,
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: const Text("Banboo Store"),
              ),
            ],
          ),
        ]
        ),
      ),
    )
    );
  }
}
