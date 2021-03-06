import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:productivitytimer/settings.dart';
import 'package:productivitytimer/timermodel.dart';
import 'package:productivitytimer/widgets.dart';

import './timer.dart';

void main() => runApp(MyApp());

final CountDownTimer timer = CountDownTimer();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // start to work with timer.
    timer.startWork();
    return MaterialApp(
      title: 'My Work Timer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatelessWidget {
  final double defaultPadding = 5.0;

  @override
  Widget build(BuildContext context) {
    // Add Setting as popUpMenuItem to the list of items.
    final List<PopupMenuItem<String>> menuItems = List<PopupMenuItem<String>>();
    menuItems.add(
      PopupMenuItem(
        value: 'Settings',
        child: Text('Settings'),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('My work timer'),
          actions: [
            // Add popUp menu Button.
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return menuItems.toList();
              },
              onSelected: (s) {
                if (s == 'Settings') {
                  goToSettings(context);
                }
              },
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraint) {
            // Get the width of the screen.
            final double availableWidth = constraint.maxWidth;
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                    Expanded(
                      child: ProductivityButton(
                        color: Color(0xff009688),
                        text: "Work",
                        onPressed: () => timer.startWork(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                    Expanded(
                        child: ProductivityButton(
                          color: Color(0xff607D8B),
                      text: "Short Break",
                      onPressed: () => timer.startBreak(true),
                    )),
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                    Expanded(
                      child: ProductivityButton(
                        color: Color(0xff455A64),
                        text: "Long Break",
                        onPressed: () => timer.startBreak(false),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                  ],
                ),
                StreamBuilder(
                    initialData: '00:00',
                    stream: timer.stream(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      TimerModel timer = (snapshot.data == '00:00')
                          ? TimerModel('00:00', 1)
                          : snapshot.data;
                      return Expanded(
                          child: CircularPercentIndicator(
                            radius: availableWidth / 2,
                            lineWidth: 10.0,
                            percent: timer.percent,
                            center: Text(timer.time,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline4),
                            progressColor: Color(0xff009688),
                          ));
                    }),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                    Expanded(
                        child: ProductivityButton(
                            color: Color(0xff212121),
                            text: 'Stop',
                            onPressed: () => timer.stopTimer())),
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                    Expanded(
                        child: ProductivityButton(
                          color: Color(0xff009688),
                          text: 'Restart',
                          onPressed: () => timer.startTimer(),
                        )),
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                  ],
                )
              ],
            );
          },
        ));
  }

  // The method used to go Settings Route.
  void goToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }
}
