import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:sizer/sizer.dart';

class InAppView extends StatefulWidget {
  InAppView(this.url, this.text, {Key? key}) : super(key: key);
  String url,text;
  @override
  _InAppViewState createState() => _InAppViewState();
}

class _InAppViewState extends State<InAppView> {
  // InAppWebViewController webView;
  double progress = 0;
  bool isShow = false;
  int current = 0;

  @override
  void initState() {
    super.initState();
    isShow = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.BACKGROUND_BLUE_HAZE,
        appBar: PreferredSize(
          preferredSize:
          Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
          child: Container(
            padding: EdgeInsets.only(bottom: 20),
            constraints: BoxConstraints.expand(),
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => AppNavigation.navigatorPop(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          // _currentUser.userType == UserType.user
                          AppNavigation.navigatorPop(context);
                          // : AppNavigation.navigateTo(context, MeneScreen());
                        },
                        icon: Icon(
                          // _currentUser.userType == UserType.user
                          Icons.arrow_back,
                          // : Icons.menu,
                          color: Colors.white,
                        )),
                    Spacer(
                      flex: 5,
                    ),
                    Text(
                      widget.text.toUpperCase(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Spacer(
                      flex: 7,
                    ),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
            ),
          ),
        ),
        body: Container(
          height: 100.h,
          color: Colors.white,
          width: 100.w,
          child: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: InAppWebView(
              key: webViewKey,
              // contextMenu: contextMenu,
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              // initialFile: "assets/index.html",
              // initialUserScripts: UnmodifiableListView<UserScript>([]),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },

              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              // shouldOverrideUrlLoading: (controller, navigationAction) async {
              //   var uri = navigationAction.request.url!;
              //
              //   if (![
              //     "http",
              //     "https",
              //     "file",
              //     "chrome",
              //     "data",
              //     "javascript",
              //     "about"
              //   ].contains(uri.scheme)) {
              //     if (await canLaunch(url)) {
              //       // Launch the App
              //       await launch(
              //         url,
              //       );
              //       // and cancel the request
              //       return NavigationActionPolicy.CANCEL;
              //     }
              //   }
              //
              //   return NavigationActionPolicy.ALLOW;
              // },
              // onLoadStop: (controller, url) async {
              //   pullToRefreshController.endRefreshing();
              //   setState(() {
              //     this.url = url.toString();
              //     urlController.text = this.url;
              //   });
              // },
              // onLoadError: (controller, url, code, message) {
              //   pullToRefreshController.endRefreshing();
              // },
              // onProgressChanged: (controller, progress) {
              //   if (progress == 100) {
              //     pullToRefreshController.endRefreshing();
              //   }
              //   setState(() {
              //     this.progress = progress / 100;
              //     urlController.text = this.url;
              //   });
              // },
              // onUpdateVisitedHistory: (controller, url, androidIsReload) {
              //   setState(() {
              //     this.url = url.toString();
              //     urlController.text = this.url;
              //   });
              // },
              onConsoleMessage: (controller, consoleMessage) {},
            ),
          ),
        ),
      ),
    );
  }
// Align(alignment: Alignment.center, child: _buildProgressBar()),

// Widget _buildProgressBar() {
  //   if (progress != 1.0) {
  //     return CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),);
  //   }
  //   return Container();
  // }
}
