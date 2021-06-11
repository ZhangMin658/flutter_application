import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:ads/ads.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CaregoriesCarouselWidget.dart';
import '../elements/DeliveryAddressBottomSheetWidget.dart';
import '../elements/FoodsCarouselWidget.dart';
import '../elements/GridWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';


class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;

  final String appId = Platform.isIOS
      ? 'ca-app-pub-8951505955430309~8239474174'
      : 'ca-app-pub-8951505955430309~8239474174';
  final String bannerUnitId = Platform.isIOS
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  final String screenUnitId = Platform.isIOS
      ? 'ca-app-pub-8951505955430309/3518981609'
      : 'ca-app-pub-8951505955430309/3518981609';
  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var eventListener = (MobileAdEvent event) {
      if (event == MobileAdEvent.clicked) {
        print("The opened ad is clicked on.");
      }
    };

    Config.ads = Ads(
      appId,
      //bannerUnitId: bannerUnitId,
      screenUnitId: screenUnitId,
      keywords: <String>['ibm', 'computers'],
      contentUrl: 'http://www.ibm.com',
      childDirected: false,
      testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
      testing: false,
      listener: eventListener,
    );
    Config.ads.eventListener = (MobileAdEvent event) {
      switch (event) {
        case MobileAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case MobileAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case MobileAdEvent.clicked:
          print("The opened ad was clicked on.");
          break;
        case MobileAdEvent.impression:
          print("The user is still looking at the ad. A new ad came up.");
          break;
        case MobileAdEvent.opened:
          print("The Ad is now open.");
          break;
        case MobileAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case MobileAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        default:
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    MobileAdListener eventHandler = (MobileAdEvent event) {
      print("This is an event handler.");
    };

    Config.ads.bannerListener = (MobileAdEvent event) {
      switch (event) {
        case MobileAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case MobileAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case MobileAdEvent.clicked:
          print("The opened ad was clicked on.");
          break;
        case MobileAdEvent.impression:
          print("The user is still looking at the ad. A new ad came up.");
          break;
        case MobileAdEvent.opened:
          print("The Ad is now open.");
          break;
        case MobileAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case MobileAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        default:
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    //Config.ads.removeBanner(eventHandler);

    Config.ads.removeEvent(eventHandler);

    Config.ads.removeScreen(eventHandler);

    Config.ads.screenListener = (MobileAdEvent event) {
      switch (event) {
        case MobileAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case MobileAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case MobileAdEvent.clicked:
          print("The opened ad was clicked on.");
          break;
        case MobileAdEvent.impression:
          print("The user is still looking at the ad. A new ad came up.");
          break;
        case MobileAdEvent.opened:
          print("The Ad is now open.");
          break;
        case MobileAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case MobileAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        default:
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    Config.ads.videoListener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      switch (event) {
        case RewardedVideoAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case RewardedVideoAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case RewardedVideoAdEvent.opened:
          print("The ad is now open.");
          break;
        case RewardedVideoAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case RewardedVideoAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        case RewardedVideoAdEvent.rewarded:
          print("The ad has sent a reward amount.");
          break;
        case RewardedVideoAdEvent.started:
          print("You've just started playing the Video ad.");
          break;
        case RewardedVideoAdEvent.completed:
          print("You've just finished playing the Video ad.");
          break;
        default:
          print("There's a 'new' RewardedVideoAdEvent?!");
      }
    };

    VoidCallback handlerFunc = () {
      print("The opened ad was clicked on.");
    };
/*
    Config.ads.banner.loadedListener = () {
      print("An ad has loaded successfully in memory.");
    };

    Config.ads.banner.removeLoaded(handlerFunc);

    Config.ads.banner.failedListener = () {
      print("An ad failed to load into memory.");
    };

    Config.ads.banner.removeFailed(handlerFunc);

    Config.ads.banner.clickedListener = () {
      print("The opened ad is clicked on.");
    };

    Config.ads.banner.removeClicked(handlerFunc);

    Config.ads.banner.impressionListener = () {
      print("The user is still looking at the ad. A new ad came up.");
    };

    Config.ads.banner.removeImpression(handlerFunc);

    Config.ads.banner.openedListener = () {
      print("You've closed an ad and returned to your app.");
    };

    Config.ads.banner.removeOpened(handlerFunc);

    Config.ads.banner.leftAppListener = () {
      print("You left the app and gone to the ad's website.");
    };

    Config.ads.banner.removeLeftApp(handlerFunc);

    Config.ads.banner.closedListener = () {
      print("You've closed an ad and returned to your app.");

    };

    Config.ads.banner.removeClosed(handlerFunc);

    Config.ads.screen.loadedListener = () {
      print("An ad has loaded into memory.");
    };*/

    Config.ads.screen.removeLoaded(handlerFunc);

    Config.ads.screen.failedListener = () {
      print("An ad has failed to load in memory.");
    };

    Config.ads.screen.removeFailed(handlerFunc);

    Config.ads.screen.clickedListener = () {
      print("The opened ad was clicked on.");
    };

    Config.ads.screen.removeClicked(handlerFunc);

    Config.ads.screen.impressionListener = () {
      print("You've clicked on a link in the open ad.");
    };

    Config.ads.screen.removeImpression(handlerFunc);

    Config.ads.screen.openedListener = () {
      print("The ad has opened.");
    };

    Config.ads.screen.removeOpened(handlerFunc);

    Config.ads.screen.leftAppListener = () {
      print("The user has left the app and gone to the opened ad.");
    };

    Config.ads.screen.leftAppListener = handlerFunc;

    Config.ads.screen.closedListener = () {
      print("The ad has been closed. The user returns to the app.");
    };

    Config.ads.screen.removeClosed(handlerFunc);

    Config.ads.video.loadedListener = () {
      print("An ad has loaded in memory.");
    };

    Config.ads.video.removeLoaded(handlerFunc);

    Config.ads.video.failedListener = () {
      print("An ad has failed to load in memory.");
    };

    Config.ads.video.removeFailed(handlerFunc);

    Config.ads.video.clickedListener = () {
      print("An ad has been clicked on.");
    };

    Config.ads.video.removeClicked(handlerFunc);

    Config.ads.video.openedListener = () {
      print("An ad has been opened.");
    };

    Config.ads.video.removeOpened(handlerFunc);

    Config.ads.video.leftAppListener = () {
      print("You've left the app to view the video.");
    };

    Config.ads.video.leftAppListener = handlerFunc;

    Config.ads.video.closedListener = () {
      print("The video has been closed.");
    };

    Config.ads.video.removeClosed(handlerFunc);


    RewardListener rewardHandler = (String rewardType, int rewardAmount) {
      print("This is the Rewarded Video handler");
    };

    Config.ads.video.removeRewarded(rewardHandler);

    Config.ads.video.startedListener = () {
      print("You've just started playing the Video ad.");
    };

    Config.ads.video.removeStarted(handlerFunc);

    Config.ads.video.completedListener = () {
      print("You've just finished playing the Video ad.");
    };

    Config.ads.video.removeCompleted(handlerFunc);

    //Config.ads.showBannerAd(state: this, anchorOffset: null);
  }

  @override
  void dispose() {
    Config.ads?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              value.appName ?? S.of(context).home,
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
//        title: Text(
//          settingsRepo.setting?.value.appName ?? S.of(context).home,
//          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
//        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshHome,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CardsCarouselWidget(restaurantsList: _con.topRestaurants, heroTag: 'home_top_restaurants'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(
                  onClickFilter: (event) {
                    widget.parentScaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.category,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).food_categories,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              CategoriesCarouselWidget(
                categories: _con.categories,
                that: this,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.trending_up,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).most_popular,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridWidget(
                  restaurantsList: _con.popularRestaurants,
                  heroTag: 'home_restaurants',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  leading: Icon(
                    Icons.recent_actors,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).recent_reviews,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ReviewsListWidget(reviewsList: _con.recentReviews),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
