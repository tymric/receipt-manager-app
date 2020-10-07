import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO toast message in settings_widget.dart
class SettingsWidget extends StatelessWidget {
  final _textController = TextEditingController();
  String ipv4 = "";
  final SharedPreferences sharedPreferences;

  SettingsWidget(this.sharedPreferences);

  void dispose() {
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (sharedPreferences.getString("ipv4") != null) {
      ipv4 = sharedPreferences.getString("ipv4");
      _textController.value = TextEditingValue(
        text: ipv4,
        selection: TextSelection.fromPosition(
          TextPosition(offset: ipv4.length),
        ),
      );
    }

    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.white,
                      primaryColorDark: Colors.white,
                    ),
                    child: serverTextfield())),
            new Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                        onPressed: () async {
                          final ipv4_regex =
                              "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\$";

                          RegExp ipRegex = new RegExp(ipv4_regex,
                              caseSensitive: false, multiLine: false);

                          if (ipv4.isEmpty || !ipRegex.hasMatch(ipv4)) {
                            showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                      image: Image.asset(
                                        "assets/robot.gif",
                                        fit: BoxFit.fill,
                                      ),
                                      title: Text(
                                        'Invalid server ip',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      entryAnimation:
                                          EntryAnimation.BOTTOM_RIGHT,
                                      description: Text(
                                        'The given submited server ip appear invalid. Please try again.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
                                      ),
                                      onCancelButtonPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      onOkButtonPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ));
                            return;
                          } else {
                            const port = 8721;
                            final stream = NetworkAnalyzer.discover2(
                              "192.168.0",
                              port,
                              timeout: Duration(milliseconds: 5000),
                            );

                            bool found = false;
                            stream.listen((NetworkAddress addr) {
                              if (addr.exists) {
                                if (addr.ip.trim() == ipv4.trim()) {
                                  sharedPreferences.setString("ipv4", ipv4);
                                  Scaffold.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                      content: Text("Server ip is set."),
                                      backgroundColor: Colors.green,
                                    ));
                                  found = true;
                                }
                              }
                            }).onDone(() {
                              if (!found) sendServerAlert(context);
                              // TODO remove
                              sharedPreferences.setString("ipv4", ipv4);

                              Scaffold.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                  content: Text("Server ip could not be set."),
                                  backgroundColor: Colors.red,
                                ));
                            });
                          }
                        },
                        child: Icon(Icons.done_all),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueAccent)))
          ],
        ),
      ),
    );
  }

  sendServerAlert(BuildContext _context) {
    showDialog(
        context: _context,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset(
                "assets/robot.gif",
                fit: BoxFit.fill,
              ),
              title: Text(
                'No server responding',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              entryAnimation: EntryAnimation.BOTTOM_RIGHT,
              description: Text(
                'No server is responding on this ip address. Please check if the server is running.',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onCancelButtonPressed: () {
                Navigator.of(_context).pop();
              },
              onOkButtonPressed: () {
                Navigator.of(_context).pop();
              },
            ));
  }

  serverTextfield() {
    return new TextFormField(
      controller: _textController,
      style: TextStyle(color: Colors.white),
      onChanged: (value) {
        ipv4 = value;
      },
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.white)),
        hintText: 'Server ip',
        labelText: 'Server ip address',
        helperText: "Set the image server ip.",
        prefixIcon: const Icon(
          Icons.network_wifi,
          color: Colors.white,
        ),
        prefixText: ' ',
      ),
    );
  }
}
