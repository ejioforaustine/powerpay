import 'package:flutter/material.dart';

bool isMoreSelected = true;




class MyFlowDelegateButtons implements FlowDelegate {



  @override

  void paintChildren(FlowPaintingContext context){

    for (int i=0; i < context.childCount; i++){

      const double offset =  50;

      context.paintChild(0, transform: Matrix4.identity());
      context.paintChild(0, transform: Matrix4.translationValues(offset, offset, 0));

    }


  }

  @override

  bool shouldRepaint (MyFlowDelegateButtons oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    // TODO: implement getConstraintsForChild
    throw UnimplementedError();
  }

  @override
  Size getSize(BoxConstraints constraints) {
    // TODO: implement getSize
    throw UnimplementedError();
  }

  @override
  bool shouldRelayout(covariant FlowDelegate oldDelegate) {
    // TODO: implement shouldRelayout
    throw UnimplementedError();
  }



}



class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i)!.width * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          0,
          dx * menuAnimation.value,
          0,
        ),
      );
    }
  }
}


