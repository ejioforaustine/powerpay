import 'package:flutter/material.dart';

import '../../UIKonstant/KUiComponents.dart';

class PopUps {
  static void morePopUp(BuildContext context) {
    Future<bool> shouldPop() async {
      bool Pop = false;
      return Pop;
    }

    showModalBottomSheet(
        backgroundColor: kbackgroundColorLightMode,
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              return shouldPop();
            },
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter myupdate) {
              return Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    color: kbackgroundColorLightMode),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 20),
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: ktextColor)),
                          child: Center(
                            child: ListTile(
                              leading: Container(
                                clipBehavior: Clip.hardEdge,
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kbackgroundFunctionButtonColor),
                                child: const Center(
                                    child: Icon(
                                  Icons.monitor,
                                  color: Colors.black,
                                  size: 20,
                                )),
                              ),
                              title: Text('Cable TV',style: TextStyle(color: ktextColor),),
                            ),
                          ),
                        ),
                      ), //cable TV

                      Padding(
                        padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 20),
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: ktextColor)),
                          child: Center(
                            child: ListTile(
                              leading: Container(
                                clipBehavior: Clip.hardEdge,
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kbackgroundFunctionButtonColor),
                                child: const Center(
                                    child: Icon(
                                      Icons.wheelchair_pickup,
                                      color: Colors.black,
                                      size: 20,
                                    )),
                              ),
                              title: Text('Insurance',style: TextStyle(color: ktextColor),),
                              trailing: Text('Coming soon',style: TextStyle(color: ktextColor.withOpacity(0.3),fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ),
                      ),// Insurance

                      Padding(
                        padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 20),
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: ktextColor)),
                          child: Center(
                            child: ListTile(
                              leading: Container(
                                clipBehavior: Clip.hardEdge,
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kbackgroundFunctionButtonColor),
                                child: const Center(
                                    child: Icon(
                                      Icons.airplane_ticket_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    )),
                              ),
                              title: Text('Flight Bookings',style: TextStyle(color: ktextColor),),
                              trailing: Text('Coming soon',style: TextStyle(color: ktextColor.withOpacity(0.3),fontStyle: FontStyle.italic),
                              ),

                            ),
                          ),
                        ),
                      ),// Flights





                       Padding(
                         padding: const EdgeInsets.only(left: 16,right: 16,top: 30),
                         child: GestureDetector(
                           onTap: (){
                             Navigator.pop(context);
                           },
                           child: Container(
                             height: 60,
                             width: MediaQuery.of(context).size.width,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(16),
                               color: Colors.black
                                 ),
                             child: const Center(
                               child: Text('Close',style: TextStyle(color: Colors.white),)

                             ),
                           ),
                         ),
                       ),

                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
}
