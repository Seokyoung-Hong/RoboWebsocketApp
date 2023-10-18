import 'package:flutter/material.dart';
import 'package:robotrafficlight/shared/menu_bottom.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const List<String> markers = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
];

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

visionMarker(data) {
  try {
    if (data != null) {
      return Image.asset('assets/images/$data.png');
    }
  } catch (e) {}
  return const Text('No Image');
}

WebSocketChannel webSocketChannel(ip) {
  return IOWebSocketChannel.connect(Uri.parse('ws://$ip/ws'));
}

class _LocalScreenState extends State<LocalScreen> {
 
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // widget.channel.sink.add('Hello!');

    return Scaffold(
      bottomNavigationBar: const MenuBottom(),
      body: Material(
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Row(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              //
              // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
              // action in the IDE, or press "p" in the console), to see the
              // wireframe for each widget.
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  // width: MediaQuery.of(context).size.width * 0.2,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownMenu(
                          initialSelection: markers.first,
                          dropdownMenuEntries: markers
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  // flex: 10,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: newMethod(),
                ),
                // SizedBox(
                //     height: (MediaQuery.of(context).size.height -
                //             MediaQuery.of(context).padding.top) *
                //         0.8,
                //     width: MediaQuery.of(context).size.width * 0.6,
                //     child: Image.asset('assets/images/A.png')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget newMethod() {
    return StreamBuilder(
      stream: widget.channel.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return visionMarker(snapshot.data);
        } else {
          return const Text('No Image');
        }
      },
    );
  }
