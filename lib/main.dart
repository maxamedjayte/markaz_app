import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  
  MyApp({super.key});
  
  WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            print('Loading progress: $progress');
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            print(url);
            // Check if the current URL is the homepage
            if (url == 'https://markazujaamicalummah.site/' || url == 'https://markazujaamicalummah.site') {
              // Redirect to the /app URL
              controller?.loadRequest(Uri.parse('https://markazujaamicalummah.site/app'));
            }
          },
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
      ..loadRequest(Uri.parse('https://markazujaamicalummah.site/app/'));

    return MaterialApp(
      title: 'Markazul Jaamic Al Ummah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: WillPopScope(
        onWillPop: () async {
          if (await controller!.canGoBack()) {
            await controller!.goBack();
            return false; // Prevent the default back action
          }
          return true; // Allow the default back action
        },
        child: Scaffold(
          body: SafeArea(
            child: WebViewWidget(controller: controller!),
          ),
        ),
      ),
    );
  }
}
