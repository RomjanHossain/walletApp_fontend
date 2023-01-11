import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:wallet_ui/Pages/buttom_navigation.dart';
import 'package:wallet_ui/Pages/screen/Profile/add_fund.dart';
import 'package:wallet_ui/Pages/screen/Notification/notificatio_page.dart';
import 'package:wallet_ui/models/json_serialize/user_model.dart';
import 'package:wallet_ui/models/pages/giftCard_items.dart';
import 'package:wallet_ui/models/services/mobile_banking_service.dart';
import 'package:wallet_ui/services/user_api.dart';
import '../models/pages/bank_item.dart';
import '../models/pages/mb_items.dart';
import '../models/pages/recharge_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();
    Future _Storage() async {
      var hometoken = await storage.read(key: 'token');
      print(hometoken);
    }

    //Set the lenght ..
    TabController _tabController = TabController(length: 4, vsync: this);
    //
    //Pull refresh ..
    Future<void> _handleRefresh() async {
      return await Future.delayed(const Duration(
        seconds: 2,
      ));
    }

    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () {
          _Storage();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F8FB),
          // backgroundColor: Colors.blue[50],
          // backgroundColor: Color.fromARGB(255, 243, 253, 255),
          appBar: AppBar(
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.white,
            leadingWidth: 150,
            leading: Container(
              margin: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const
                  //   ()),
                  // );
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const BottomNavigation(),
                        transitionDuration: const Duration(seconds: 0),
                        transitionsBuilder: (_, a, __, c) =>
                            FadeTransition(opacity: a, child: c),
                      ),
                      // MaterialPageRoute(builder: (context) => BottomNavigation()),
                      (route) => false);
                },
                child: SvgPicture.asset('assets/wallet_logo.svg'),
                // child: const Image(
                //   image: AssetImage(
                //     'assets/Group 255.png',
                //   ),
                // ),
              ),
            ),
            // title: Container(
            //   alignment: Alignment.centerLeft,
            //   child: GestureDetector(
            //     onTap: () {},
            //     child: Image(
            //       image: AssetImage('assets/Group 255.png'),
            //     ),
            //   ),
            // ),
            actions: [
              Container(
                padding: const EdgeInsets.only(
                  right: 4,
                ),
                child: IconButton(
                  iconSize: 10,
                  icon: SvgPicture.asset(
                    'assets/notifications.svg',
                    height: 22,
                  ),
                  // icon: Image.asset('assets/noti.png'),
                  onPressed: () {
                    // sending to notification page using (PageRouteBuilder)

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const NotificationPage(),
                        transitionDuration: const Duration(seconds: 0),
                        transitionsBuilder: (_, a, __, c) =>
                            FadeTransition(opacity: a, child: c),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          //Pul down Refresh...
          body: LiquidPullToRefresh(
            borderWidth: 2,
            animSpeedFactor: 2,
            showChildOpacityTransition: false,

            // springAnimationDurationInMilliseconds: 300,
            backgroundColor: const Color.fromARGB(255, 105, 183, 247),
            // color: Colors.grey,
            color: const Color(0xFFF4F8FB),

            //End of pull down refresh..

            onRefresh: _handleRefresh,
            // height: 50,
            child: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  margin: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      //
                      //
                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => const AddFund(),
                                  transitionDuration:
                                      const Duration(seconds: 0),
                                  transitionsBuilder: (_, a, __, c) =>
                                      FadeTransition(opacity: a, child: c),
                                ),
                              );
                            },
                            child: SvgPicture.asset('assets/tk.svg'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // TextButton(
                          //     onPressed: () {
                          //       print(
                          //           // ignore: unnecessary_string_interpolations
                          //           '${Provider.of<UserProvider>(context, listen: false).useR.username ?? "fsdf"}');
                          //     },
                          //     child: const Text('hola')),
                          Column(
                            children: [
                              FutureBuilder(
                                future: getBalance(
                                    "http://zune360.com/api/user/current_balance/"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      '\৳ ' + snapshot.data.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }

                                  return const Text('');
                                },
                              ),
                              // Text(context
                              //     .read<UserProvider>()
                              //     .useR
                              //     .current_balance
                              //     .toString()),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Current balance',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: TabBar(
                          isScrollable: true,
                          indicatorColor: Colors.transparent,
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.black,
                          controller: _tabController,
                          tabs: const [
                            //Mobile Banking Tab..
                            Tab(
                              child: Text(
                                'Mobile Banking',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            //Bank tab..
                            Tab(
                              child: Text(
                                'Bank',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            //Mobile Recharge tab..
                            Tab(
                              child: Text(
                                'Mobile Recharge',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            //Gift Card tabs..
                            Tab(
                              child: Text(
                                'Gift Card',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(32),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // const ApiTest(),
                              const MobileBankingItems(),
                              BankingItems(),
                              const MobileRechargeItem(),
                              GiftCardItems(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// print('btn clicked');
// CupertinoPageRoute(
//     builder: ((context) => const NotificationPage()),);
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (ctx) => const NotificationPage(),
//   ),
// );
