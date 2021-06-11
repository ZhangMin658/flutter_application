import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/user_repository.dart';
import 'package:food_delivery_app/config.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCarts({String message}) async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (carts.isNotEmpty) {
        calculateSubtotal();
      }
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
      onLoadingCartDone();
    });
  }

  void onLoadingCartDone() {}

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    });
  }

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
    });
    listenForCarts(message: S.of(context).carts_refreshed_successfuly);
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      calculateSubtotal();
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).the_food_was_removed_from_your_cart(_cart.food.name)),
      ));
    });
  }

  // void calculateSubtotal() async {
  //   subTotal = 0;
  //   carts.forEach((cart) {
  //     subTotal += cart.food.price;
  //     cart.extras.forEach((element) {
  //       subTotal += element.price;
  //     });
  //     subTotal *= cart.quantity;
  //   });
  //   if (Helper.canDelivery(carts[0].food.restaurant, carts: carts)) {
  //     deliveryFee = carts[0].food.restaurant.deliveryFee;
  //   }
  //   taxAmount = (subTotal + deliveryFee) * carts[0].food.restaurant.defaultTax / 100;
  //   total = subTotal + taxAmount + deliveryFee;
  //   setState(() {});
  // }
  void calculateSubtotal() async {
    subTotal = 0;
    carts.forEach((cart) {

      if(cart.food.restaurant.isofferset){
        subTotal += cart.quantity * cart.food.price;
      } else {
        subTotal += cart.quantity * cart.food.price;
      }
      cart.extras.forEach((element) {
        if(cart.food.restaurant.isofferset){
          subTotal += element.price * 0.9 *  cart.quantity;
        } else {
          subTotal += element.price * cart.food.price * cart.quantity;
        }
      });
    });
    if (Helper.canDelivery(carts[0].food.restaurant, carts: carts)) {
      deliveryFee = carts[0].food.restaurant.deliveryFee;
    }
    taxAmount = (subTotal + deliveryFee) * carts[0].food.restaurant.defaultTax / 100;
    total = subTotal + taxAmount + deliveryFee;
    setState(() {});
  }
  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  void goCheckout(BuildContext context) {
    if (!currentUser.value.profileCompleted()) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).completeYourProfileDetailsToContinue),
        action: SnackBarAction(
          label: S.of(context).settings,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pushNamed('/Settings');
          },
        ),
      ));
    } else {
      if (carts[0].food.restaurant.closed) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_restaurant_is_closed_),
        ));
      } else {
        List<bool> selected = List<bool>(carts.length);
        List<String> selectedoptions = List<String>(carts.length);
        List<List<bool>> selectbuttons;

        selectbuttons = List.generate(carts.length, (index) => List.generate(4, (index) => false));
        selectedoptions = List.generate(carts.length, (index) => '');

        bool all_check = false;

        showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                  builder:(context, setStates) {
                    for(int i = 0; i < carts.length; i++){
                      selected[i] = false;
                    }
                    for(int j = 0; j < carts.length; j++){
                        if(selectbuttons[j][0] || selectbuttons[j][1] || selectbuttons[j][2] || selectbuttons[j][3]){
                          selected[j] = true;
                        }
                         if(carts[j].food.option4.length == 0 && carts[j].food.option1.length == 0 && carts[j].food.option2.length == 0 && carts[j].food.option3.length == 0 && carts[j].food.option5.length == 0 && carts[j].food.option6.length == 0 && carts[j].food.option7.length == 0 && carts[j].food.option8.length == 0 && carts[j].food.option9.length == 0 && carts[j].food.option10.length == 0 && carts[j].food.option11.length == 0 && carts[j].food.option12.length == 0 && carts[j].food.option13.length == 0 && carts[j].food.option14.length == 0 && carts[j].food.option15.length == 0){
                           selected[j] = true;
                         }
                    }
                    int count = 0;
                    for(int j = 0; j < selected.length; j++){
                      if(selected[j]) count++;
                    }
                    if(count == selected.length)
                      all_check = true;
                    else all_check = false;
                    return new Dialog(
                      child: Container(
                        color: Colors.black12,
                        width: MediaQuery.of(context).size.width - 50, height: MediaQuery.of(context).size.height * 3 / 4,
                        padding: EdgeInsets.all(20),
                        child:Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child:  Column(
                                children: <Widget>[
                                  for(int i = 0; i < carts.length; i++)
                                    Container(
                                      padding: EdgeInsets.only(top: 5, bottom: 5),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                child: CachedNetworkImage(
                                                  height: 60,
                                                  width: 60,
                                                  fit: BoxFit.cover,
                                                  imageUrl: carts[i].food.image.thumb,
                                                  placeholder: (context, url) => Image.asset(
                                                    'assets/img/loading.gif',
                                                    fit: BoxFit.cover,
                                                    height: 90,
                                                    width: 90,
                                                  ),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Flexible(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            carts[i].food.name,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            style: Theme.of(context).textTheme.subtitle1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              carts[i].food.question,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            child:Column(
                                              children: <Widget>[
                                                carts[i].food.option1.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color: !selectbuttons[i][0] ? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option1,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][0] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][0] = !selectbuttons[i][0];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option2.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color:! selectbuttons[i][1]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option2,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][1] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][1] = !selectbuttons[i][1];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option3.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color: !selectbuttons[i][2] ? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option3,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][2] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][2] = !selectbuttons[i][2];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option4.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color: !selectbuttons[i][3]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option4,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][3] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][3] = !selectbuttons[i][3];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option5.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color: !selectbuttons[i][4] ? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option5,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][2] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][2] = !selectbuttons[i][2];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option6.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color:! selectbuttons[i][5]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option6,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][1] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][1] = !selectbuttons[i][1];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option7.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color:! selectbuttons[i][6]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option7,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][1] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][1] = !selectbuttons[i][1];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option8.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color:! selectbuttons[i][7]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option8,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][1] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][1] = !selectbuttons[i][1];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option9.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color:! selectbuttons[i][8]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option9,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][1] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][1] = !selectbuttons[i][1];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option10.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color:! selectbuttons[i][9]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option10,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][1] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][1] = !selectbuttons[i][1];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option11.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color:! selectbuttons[i][10]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option11,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][1] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][1] = !selectbuttons[i][1];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option12.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color:! selectbuttons[i][11]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option12,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][1] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][1] = !selectbuttons[i][1];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option13.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color:! selectbuttons[i][12]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option13,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][1] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][1] = !selectbuttons[i][1];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option14.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color:! selectbuttons[i][13]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option14,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][1] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][1] = !selectbuttons[i][1];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                                carts[i].food.option15.length != 0 ?
                                                Container(
                                                  child: DecoratedBox(
                                                    decoration:
                                                    ShapeDecoration(shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)), color:! selectbuttons[i][14]? Colors.white: Colors.grey),
                                                    child: OutlineButton(
                                                      highlightedBorderColor: Colors.white,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .065,
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Center(
                                                            child: Text(carts[i].food.option15,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: !selectbuttons[i][1] ? Colors.white: Colors.grey),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      onPressed: () {
                                                        setStates(() {
                                                          selectbuttons[i][1] = !selectbuttons[i][1];
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                ):Container(),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  SizedBox(
                                    height: 70,
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 0,
                              left: 0,
                              child:Container(
                                child: DecoratedBox(
                                  decoration:
                                  ShapeDecoration(shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)), color: !all_check ? Colors.white: Colors.grey),
                                  child: OutlineButton(
                                    highlightedBorderColor: Colors.white,
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * .065,
                                      width: MediaQuery.of(context).size.width * .75,
                                      child: Center(
                                          child: Text('Checkout',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,)),
                                    ),
                                    borderSide: BorderSide(
                                        width: 1,
                                        style: BorderStyle.solid,
                                        color: !all_check ? Colors.white: Colors.grey),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () {
                                      if(all_check){
                                        for(int k = 0; k < carts.length; k++){
                                          if(carts[k].food.option1.length != 0 && selectbuttons[k][0])
                                            selectedoptions[k] += carts[k].food.option1;
                                          if(carts[k].food.option2.length != 0 && selectbuttons[k][1])
                                            selectedoptions[k] += ',' + carts[k].food.option2;
                                          if(carts[k].food.option3.length != 0 && selectbuttons[k][2])
                                            selectedoptions[k] += ',' + carts[k].food.option3;
                                          if(carts[k].food.option4.length != 0 && selectbuttons[k][3])
                                            selectedoptions[k] += ',' + carts[k].food.option4;
                                          if(carts[k].food.option5.length != 0 && selectbuttons[k][4])
                                            selectedoptions[k] += ',' + carts[k].food.option5;
                                          if(carts[k].food.option6.length != 0 && selectbuttons[k][5])
                                            selectedoptions[k] += carts[k].food.option6;
                                          if(carts[k].food.option7.length != 0 && selectbuttons[k][6])
                                            selectedoptions[k] += ',' + carts[k].food.option7;
                                          if(carts[k].food.option8.length != 0 && selectbuttons[k][7])
                                            selectedoptions[k] += ',' + carts[k].food.option8;
                                          if(carts[k].food.option9.length != 0 && selectbuttons[k][8])
                                            selectedoptions[k] += ',' + carts[k].food.option9;
                                          if(carts[k].food.option10.length != 0 && selectbuttons[k][9])
                                            selectedoptions[k] += ',' + carts[k].food.option10;
                                          if(carts[k].food.option11.length != 0 && selectbuttons[k][10])
                                            selectedoptions[k] += carts[k].food.option11;
                                          if(carts[k].food.option12.length != 0 && selectbuttons[k][11])
                                            selectedoptions[k] += ',' + carts[k].food.option12;
                                          if(carts[k].food.option13.length != 0 && selectbuttons[k][12])
                                            selectedoptions[k] += ',' + carts[k].food.option13;
                                          if(carts[k].food.option14.length != 0 && selectbuttons[k][13])
                                            selectedoptions[k] += ',' + carts[k].food.option14;
                                          if(carts[k].food.option15.length != 0 && selectbuttons[k][14])
                                            selectedoptions[k] += ',' + carts[k].food.option15;
                                          if(selectedoptions[k].length != 0){
                                            if(selectedoptions[k].startsWith(',')){
                                              selectedoptions[k] = selectedoptions[k].substring(1,selectedoptions[k].length);
                                            }
                                          }

                                        }
                                        Config.select_options = selectedoptions;
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushNamed('/DeliveryPickup');
                                      }
                                    },
                                  ),
                                ),
                              )
                            )
                          ],
                        )
                      ),
                    );
                  });
            }
        );
        // Navigator.of(context).pushNamed('/DeliveryPickup');
      }
    }
  }
}
