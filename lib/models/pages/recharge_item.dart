import 'package:flutter/material.dart';
import 'package:wallet_ui/models/pages/recharge_detailes.dart';
import 'package:wallet_ui/models/services/mobile_banking_service.dart';

class MobileRechargeItem extends StatelessWidget {
  const MobileRechargeItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //!Using Future Builder..
    return FutureBuilder(
      //!Calling getURL..
      future: getmethod('http://zune360.com/api/user/recharge/'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.only(top: 50),
            alignment: Alignment.topCenter,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
            ),
          );
        } else {
          //! Using GridView Builder..
          return GridView.builder(
//Calling api lenght.
            itemCount: snapshot.data!.length,
            // shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 21,
            ),
            itemBuilder: (context, dynamic index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => RechargeFormPage(
                        name: snapshot.data[index]['name'].toString(),
                        logo: getDomain() +
                            snapshot.data[index]['logo'].toString(),
                        type: snapshot.data[index]['type'].toString(),
                      ),
                      transitionDuration: const Duration(milliseconds: 300),
                      transitionsBuilder: (_, a, __, c) =>
                          FadeTransition(opacity: a, child: c),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(
                        getDomain() + snapshot.data[index]['logo'].toString(),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
