import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magnetgram/helper/lang.dart';
import 'package:magnetgram/helper/style.dart';

class MyDialog extends StatefulWidget {
  final BuildContext context;
  final String message;

//  final String okText;
//  final EnumProperty type;
  final String okText;
  final VoidCallback onOkPressed;
  final VoidCallback onCancelPressed;

//  final Function(int) onOkPressed;

  const MyDialog(
      {@required this.context,
      @required this.message,
      this.onOkPressed,
      this.onCancelPressed,
      this.okText});

  @override
  State<StatefulWidget> createState() => MyDialogState();
}

class MyDialogState extends State<MyDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(50.0),
            margin: const EdgeInsets.all(50.0),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    widget.message,
                    textDirection: TextDirection.rtl,
                    style: Styles.TEXTSTYLE,
                  ),
                ),
                Row(
                  children: <Widget>[
                    //cancel button
                    Expanded(
                      child: RaisedButton.icon(
                        onPressed: () async {
                          Navigator.pop(widget.context);
                          widget.onCancelPressed();
                        },
                        padding: EdgeInsets.all(4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10.0),
                                right: Radius.circular(
                                    widget.onOkPressed == null ? 10.0 : 0))),
                        icon: Icon(
                          widget.onOkPressed == null
                              ? Icons.check
                              : Icons.clear,
                          color: Colors.white,
                          textDirection: TextDirection.rtl,
                        ),
                        label: Text(
                          widget.onOkPressed != null
                              ? Lang.get(Lang.CANCEL)
                              : Lang.get(Lang.OK),
                          style: Styles.TABSELECTEDSTYLE,
                        ),
                        textColor: Colors.white,
                        splashColor: Styles.secondaryColor,
                        color: widget.onOkPressed != null
                            ? Styles.cancelColor
                            : Styles.primaryColor,
                      ),
                    ),

                    //accept button
                    widget.onOkPressed != null
                        ? Expanded(
                            child: RaisedButton.icon(
                              onPressed: () async {
                                Navigator.pop(widget.context);
                                widget.onOkPressed();
                              },
                              padding: EdgeInsets.all(4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(10.0))),
                              icon: Icon(
                                Icons.check,
                                color: Colors.white,
                                textDirection: TextDirection.rtl,
                              ),
                              label: Text(
                                widget.okText ?? Lang.get(Lang.OK),
                                style: Styles.TABSELECTEDSTYLE,
                              ),
                              textColor: Colors.white,
                              splashColor: Styles.secondaryColor,
                              color: Styles.successColor,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
