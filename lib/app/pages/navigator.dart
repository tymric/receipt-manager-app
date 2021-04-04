/*
 * Copyright (c) 2020 - 2021 : William Todt
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:receipt_manager/app/pages/history/history_view.dart';
import 'package:receipt_manager/app/pages/home/home_view.dart';
import 'package:receipt_manager/app/pages/settings/settings_view.dart';
import 'package:receipt_manager/app/pages/stats/stat_view.dart';

class NavigatorPage extends View {
  NavigatorPage({Key key}) : super(key: key);

  @override
  NavigatorState createState() => NavigatorState();
}

class NavigatorState extends State {
  final GlobalKey _bottomNavigationKey = GlobalKey();

  int currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    HistoryPage(),
    StatsPage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              index: 0,
              items: <Widget>[
                Icon(Icons.add, color: Colors.white, size: 30),
                Icon(Icons.history, color: Colors.white, size: 30),
                Icon(Icons.analytics_outlined, color: Colors.white, size: 30),
                Icon(Icons.settings, color: Colors.white, size: 30),
              ],
              color: Colors.black,
              backgroundColor: Colors.white,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 300),
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            body: _children[currentIndex]));
  }
}