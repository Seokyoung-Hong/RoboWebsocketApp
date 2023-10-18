import 'package:flutter/material.dart';
import 'package:robotrafficlight/shared/menu_bottom.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TrafficLightScreen extends StatefulWidget {
  const TrafficLightScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TrafficLightScreen> createState() => _TrafficLightScreenState();
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

class _TrafficLightScreenState extends State<TrafficLightScreen> {
  final ipController = TextEditingController();
  final padNumController = TextEditingController();
  late WebSocketChannel? channel;
  // 웹 서버에 접속 시도
  @override
  void initState() {
    super.initState();
    try {
      channel = webSocketChannel(ipController.text);
    } catch (e) {
      try {
        channel = null;
      } catch (e) {}
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
                        TextField(
                          autofocus: true,
                          keyboardType: TextInputType.url,
                          controller: ipController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'IP with Port',
                          ),
                        ),
                        TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          controller: padNumController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Pad Number',
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            child: const Text('Connect'),
                            onPressed: () {
                              final ip = ipController.text;
                              final url = 'ws://$ip'; // 입력된 IP 주소로 WebSocket 연결
                              final newChannel =
                                  WebSocketChannel.connect(Uri.parse(url));
                              setState(
                                () {
                                  try {
                                    channel!.sink.close(); // 이전 연결 종료
                                  } catch (e) {}
                                  channel = newChannel;
                                  channel!.sink.add(padNumController.text);
                                },
                              );
                            },
                          ),
                        ), // 새로운 연결 설정
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

  newMethod() {
    if (channel == null) {
      return const Center(
        child: Text('No connection yet'),
      );
    }
    return StreamBuilder(
      stream: channel!.stream,
      builder: (context, snapshot) {
        // while (snapshot.data == null) {
        //   try {
        //     snapshot.data + 1;
        //     break;
        //   } catch (e) {
        //     print(e);
        //   }
        // }
        // return Image.asset('assets/images/${snapshot.data}.png');
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          // 수신 데이터가 존재할 경우 해당 데이터를 텍스트로 출력
          child: visionMarker(snapshot.data),
        );
      },
    );
  }

  @override
  void dispose() {
    // 채널을 닫음

    channel!.sink.close();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    //https://api.flutter.dev/flutter/dart-ui/AppLifecycleState-class.html
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        channel!.sink.close();
        break;
      case AppLifecycleState.detached:
        channel!.sink.close();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
