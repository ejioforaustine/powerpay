import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Core/Functions/Api-calls.dart';
import 'package:powerpay/Virtual%20Card/Api%20Functions/Freeze/Freeze_unFreeze.dart';

import '../../../../UIKonstant/KUiComponents.dart';
import '../../../Kvirtual constant.dart';

Future freezeOrTerminate(BuildContext context, ) {

  final List<String> cardActions = [
    'freeze',
    'unfreeze',




  ];
  bool _isLoading = false;

  return showModalBottomSheet(
      context: context,
      backgroundColor: kbackgroundColorLightMode,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {


        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void callState (){
              setState((){});
            }
            return Padding(
              padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: MediaQuery.of(context).size.height/3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //heading Text
                    Padding(
                      padding: const EdgeInsets.only(top: 24,left: 24,right: 24),
                      child: Row(
                        children: [
                          Text('Freeze / Terminate',style: GoogleFonts.inter(
                              color: kbottomNavigationIconcolor,
                              fontSize: 20,
                              fontWeight: FontWeight.w900
                          ),),

                        ],),
                    ),

                    //drop down card action
                    Padding(
                      padding: const EdgeInsets.only(top: 24,left: 24,right: 24),
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(

                          // Add Horizontal padding using menuItemStyleData.padding so it matches
                          // the menu padding when button's width is not specified.
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),

                          ),
                          // Add more decoration..
                        ),
                        hint:  Text(
                          'Select Freeze / Unfreeze',
                          style: TextStyle(
                              color: ktextColor,
                              fontSize: 12/textScaleFactor),
                        ),
                        items: cardActions
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style:  TextStyle(
                              color: ktextColor,
                              fontSize: 12/textScaleFactor,
                            ),
                          ),
                        ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please Select an Action';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //Do something when selected item is changed.
                          actionId = value.toString();
                          print(actionId);
                        },
                        onSaved: (value) {

                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        iconStyleData:  IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: ktextColor,
                          ),
                          iconSize: 24,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            color: kbackgroundColorLightMode,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 16,bottom: 16,left: 24,right: 24),
                      child: GestureDetector(
                        onTap: (){
                          AnimatedSnackBar(
                              builder: (BuildContext context) {
                                return IntrinsicHeight(
                                  child: Container(

                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.red.shade900
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Long press to delete card',style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 12/textScaleFactor,
                                                  fontWeight: FontWeight.w900),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text("Once you perform this action, the selected card will be permanently deleted.",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                      color: Colors.white,

                                                      fontSize: 8/textScaleFactor,
                                                      fontWeight: FontWeight.w200),),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );

                              }).show(context);
                          setState(() {});
                        },
                        onLongPress: ()async{

                        },
                        child: Container(
                          height: 50,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.red.shade900,
                          ),

                          child: Center(
                            child: Text('Delete Card',style: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w900),),
                          ),
                        ),
                      ),
                    ),


                    const Spacer(),
                    ///close
                    Padding(
                      padding: const EdgeInsets.only(left: 24,right:24,bottom: 16),
                      child: GestureDetector(
                        onTap: ()async{
                          _isLoading = true;
                          setState((){

                          });
                          await freezeCard(context,cardData[cardIndex]['card_id'], miniFunction().getReference(),actionId,callState);

                          _isLoading = false;
                          setState((){
                          });
                        },
                        child: Container(
                          height: 50,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.black,
                          ),

                          child: Center(
                            child: _isLoading?
                            const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white,)):
                            Text('Proceed',style: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w900),)
                            ,
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            );
          },

        );
      });
}