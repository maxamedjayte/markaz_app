import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  
  MyApp({super.key});
  
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
          print('Loading progress: $progress');
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://markazujaamicalummah.site/app'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Markazul Jaamic Al Ummah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: WillPopScope(
        onWillPop: () async {
          if (await controller.canGoBack()) {
            await controller.goBack();
            return false; // Prevent the default back action
          }
          return true; // Allow the default back action
        },
        child: Scaffold(
          body: SafeArea(
            child: WebViewWidget(controller: controller),
          ),
        ),
      ),
    );
  }
}
