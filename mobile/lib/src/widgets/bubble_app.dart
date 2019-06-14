import 'package:flutter/material.dart';
import 'bubble_home.dart';
import 'gray_input.dart';

class BubbleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BubbleAppState();
}

class _BubbleAppState extends State<BubbleApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff00d2b8),
      ),
      title: 'Bubble',
      home: BubbleHome() ??
          Builder(builder: (context) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16).copyWith(top: 96),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 64,
                        ),
                        Text(
                          'A new kind of network.',
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                        // Text(
                        // 'A new kind of network.',
                        // style: Theme.of(context)
                        //     .textTheme
                        //     .subhead
                        //     // .copyWith(color: Theme.of(context).primaryColor),
                        //     .copyWith(color: Colors.grey[700]),
                        // ),
                        Divider(
                          color: Colors.transparent,
                          height: 32,
                        ),
                        GrayInput(
                          placeholder: 'Username',
                        ),
                        Divider(color: Colors.transparent),
                        GrayInput(
                          placeholder: 'Password',
                          obscureText: true,
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 32,
                        ),
                        Text(
                          'Create an account...',
                          style: Theme.of(context)
                              .textTheme
                              .subhead
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  // alignment: Alignment.bottomCenter,
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'SIGN IN »',
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => null,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
