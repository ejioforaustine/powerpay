import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:powerpay/UIsrc/settings/Account.dart';
import 'package:powerpay/UIsrc/contact/Contact%20us.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';
import 'package:powerpay/Virtual%20Card/Kvirtual%20constant.dart';
import 'package:powerpay/Wallet/walletFace.dart';
import 'package:provider/provider.dart';

import '../UIsrc/home/Home.dart';
import '../Virtual Card/UI/virtual card Home.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);



  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}
int selectedPage = 0;

final _pageOptions = [
  const HomePage(),
  const walletTestface(),
  const VirtualCardHomePage(),
  const Accounts(),

];

class _NavigatorPageState extends State<NavigatorPage> {

  @override

  void initState(){

    super.initState();


  }


  void didChangePlatformBrightness(BuildContext context) {
    final sharedState = Provider.of<AppStateNotifier>(context, listen: false);


  }

  @override
  Widget build(BuildContext context) {
    final sharedState = Provider.of<AppStateNotifier>(context, listen: false);
    final isDarkMode = MediaQuery.of(context).platformBrightness;
    if (isDarkMode == Brightness.dark) {
      sharedState.turnDarkMode();
    } else {
      sharedState.turnLightMode();
    }

    return ChangeNotifierProvider(

      create: (_)=> AppStateNotifier(),
      child: Scaffold(
        body:Consumer<AppStateNotifier>(

          builder: (context, appState, child){




            return _pageOptions[selectedPage];
          },
        ),

        bottomNavigationBar: Consumer<AppStateNotifier>(

          builder: (context, appState, child){
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              selectedFontSize: 13,
              unselectedFontSize: 8,
              unselectedItemColor: ktextColor,
              selectedItemColor: ktextColor,
              backgroundColor: kbottomNavigation,
              selectedLabelStyle:  TextStyle(color: ktextColor),
              unselectedLabelStyle:  TextStyle(color: ktextColor),
              currentIndex: selectedPage,
              onTap: (int index) {
                setState(() {
                  selectedPage = index;
                });
              },
              items:  [
                BottomNavigationBarItem(
                    icon:  Icon(Iconsax.home4,color: kbottomNavigationIconcolor,),
                    backgroundColor: Colors.grey.shade200,
                    label: 'Home'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Iconsax.wallet,color: kbottomNavigationIconcolor,),
                    label: 'Wallet'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Iconsax.card,color: kbottomNavigationIconcolor,),
                    label: 'Card',

                ),
                BottomNavigationBarItem(
                    icon: Icon(Iconsax.profile_2user,color: kbottomNavigationIconcolor,),
                    label: 'Account'
                ),

              ],);
          },
        ),
      ),
    );
  }
}

class AppState {
  int selectedPage = 0;
}

class AppStateNotifier extends ChangeNotifier {
  final AppState _appState = AppState();

  AppState get appState => _appState;

  void turnDarkMode (){
    kBoxShadow = Colors.black.withOpacity(0.3);
    kbackgroundColorLightMode = Colors.grey.shade900;
    kairtimeAmountContainerColor = Colors.green.shade900;
    kairtimeAmountColor = Colors.green.shade100;
    ktextColor = Colors.grey.shade300;
    kbalanceContainerComponentColorLightMode = Colors.black54;
    kbalanceContainerFundButtonColorLightMode = Colors.amber;
    kbackgroundFunctionButtonColor = Colors.amber;
    kotherTextcolorGrey = Colors.grey;
    kbottomNavigation  = Colors.grey.shade900;
    kbottomNavigationIconcolor = Colors.white;
    PaymentButtonColor = popUpFormColors = Colors.black;
    StatusIcon = Brightness.light;
    popUpFormColors = Colors.grey.shade900;
    fillUpFormsColors = Colors.grey.withOpacity(0.1);
    fillUpFormsColors2 = Colors.grey.withOpacity(0.1);
    Future.delayed(const Duration(milliseconds: 300),(){notifyListeners();});
  }

  void turnLightMode (){
    kBoxShadow = Colors.grey.shade400;
    kbackgroundColorLightMode = Colors.white;
    kairtimeAmountContainerColor = Colors.green.shade100;
    kairtimeAmountColor = Colors.green.shade900;
    StatusIcon = Brightness.dark;
    ktextColor = Colors.black;
    kbalanceContainerComponentColorLightMode = Colors.black54;

    kbalanceContainerFundButtonColorLightMode = Colors.amber;

    kbackgroundFunctionButtonColor = Colors.amber.withOpacity(0.2);

    kotherTextcolorGrey = Colors.grey;
    fillUpFormsColors = Colors.grey.shade200;
    fillUpFormsColors2 = Colors.grey.shade200;

    kbottomNavigation  = Colors.grey.shade200;

    kbottomNavigationIconcolor = Colors.black;
    PaymentButtonColor = Colors.grey.shade200;
    popUpFormColors = Colors.grey.withOpacity(0.2);
    Future.delayed(const Duration(milliseconds: 300),(){notifyListeners();});
  }

  void setSelectedPage(int index) {
    _appState.selectedPage = index;
    notifyListeners();
  }
}

