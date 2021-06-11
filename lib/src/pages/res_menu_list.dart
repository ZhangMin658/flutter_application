import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/controllers/res_restaurant_controller.dart';
import 'package:food_delivery_app/src/elements/CaregoriesCarouselWidget.dart';
import 'package:food_delivery_app/src/elements/ResCaregoriesCarouselWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../elements/FoodsCarouselWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/route_argument.dart';

class ResMenuWidget extends StatefulWidget {
  @override
  _ResMenuWidgetState createState() => _ResMenuWidgetState();
  final RouteArgument routeArgument;

  ResMenuWidget({Key key, this.routeArgument}) : super(key: key);
}

class _ResMenuWidgetState extends StateMVC<ResMenuWidget> {
  ResRestaurantController _con;

  _ResMenuWidgetState() : super(ResRestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForFoods(widget.routeArgument.res_id, widget.routeArgument.id);
    _con.listenForFoodsByCategory(id: widget.routeArgument.id);
    _con.listenForCategory(id: widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _con.tmpfoods.isNotEmpty ? _con.tmpfoods[0].restaurant.name : '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.category,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  _con.category?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
            _con.foods.isEmpty
                ? CircularLoadingWidget(height: 250)
                : ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: _con.foods.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return FoodItemWidget(
                  heroTag: 'menu_list',
                  food: _con.foods.elementAt(index),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
