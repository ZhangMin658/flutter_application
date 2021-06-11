import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/cart.dart';
import 'package:food_delivery_app/src/models/category.dart';
import 'package:food_delivery_app/src/repository/cart_repository.dart';
import 'package:food_delivery_app/src/repository/category_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/food.dart';
import '../models/gallery.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../repository/food_repository.dart';
import '../repository/gallery_repository.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';

class ResRestaurantController extends ControllerMVC {
  Restaurant restaurant;
  List<Category> categories = <Category>[];
  List<Gallery> galleries = <Gallery>[];
  List<Food> tmpfoods = <Food>[];
  List<Food> foods = <Food>[];
  List<Food> resfoods = <Food>[];
  List<Food> trendingFoods = <Food>[];
  List<Food> featuredFoods = <Food>[];
  List<Review> reviews = <Review>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Category category;

  String res_id;

  ResRestaurantController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCategories();
  }
  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }
  void listenForRestaurant({String id, String message}) async {
    final Stream<Restaurant> stream = await getRestaurant(id, deliveryAddress.value);
    stream.listen((Restaurant _restaurant) {
      setState(() => restaurant = _restaurant);
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }
  void listenForFoodsByCategory({String id, String message}) async {
    final Stream<Food> stream = await getFoodsByCategory(id);
    stream.listen((Food _food) {
      print('---------------');
      print( _food.restaurant.id);
      print(res_id);
      if( _food.restaurant.id == res_id){
        setState(() {
          foods.add(_food);
        });
      }

    }, onError: (a) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });

    // resfoods.map((e) => tmpfoods.map((item) {
    //   if(e.id == item.id){
    //     foods.add(e);
    //   }
    // }));
    setState(() {});
  }


  void listenForCategory({String id, String message}) async {
    final Stream<Category> stream = await getCategory(id);
    stream.listen((Category _category) {
      setState(() => category = _category);
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }
  void listenForGalleries(String idRestaurant) async {
    final Stream<Gallery> stream = await getGalleries(idRestaurant);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForRestaurantReviews({String id, String message}) async {
    final Stream<Review> stream = await getRestaurantReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForFoods(String idRestaurant, String id) async {

    this.res_id = idRestaurant;
    print(idRestaurant);
    print(id);
    final Stream<Food> stream = await getFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => tmpfoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForTrendingFoods(String idRestaurant) async {
    final Stream<Food> stream = await getTrendingFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => trendingFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFeaturedFoods(String idRestaurant) async {
    final Stream<Food> stream = await getFeaturedFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => featuredFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshRestaurant() async {
    var _id = restaurant.id;
    restaurant = new Restaurant();
    galleries.clear();
    reviews.clear();
    featuredFoods.clear();
    listenForRestaurant(id: _id, message: S.of(context).restaurant_refreshed_successfuly);
    listenForRestaurantReviews(id: _id);
    listenForGalleries(_id);
    listenForFeaturedFoods(_id);
  }
}
