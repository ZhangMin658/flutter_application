import 'package:flutter/material.dart';

import '../../config.dart';
import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/credit_card.dart';
import '../models/food_order.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class CheckoutController extends CartController {
  Payment payment;
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  double subTotal = 0.0;
  double total = 0.0;
  CreditCard creditCard = new CreditCard();
  bool loading = true;
  GlobalKey<ScaffoldState> scaffoldKey;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }

  @override
  void onLoadingCartDone() {
    if (payment != null) addOrder(carts);
    super.onLoadingCartDone();
  }

  void addOrder(List<Cart> carts) async {
    Order _order = new Order();
    _order.foodOrders = new List<FoodOrder>();
    _order.tax = carts[0].food.restaurant.defaultTax;
    _order.deliveryFee = payment.method == 'Pay on Pickup' ? 0 : carts[0].food.restaurant.deliveryFee;
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;
    _order.deliveryAddress = settingRepo.deliveryAddress.value;
    for(int i = 0; i < carts.length; i++) {
      FoodOrder _foodOrder = new FoodOrder();
      _foodOrder.quantity = carts[i].quantity;
      _foodOrder.price = carts[i].food.price;
      _foodOrder.food = carts[i].food;
      _foodOrder.extras = carts[i].extras;
      _foodOrder.options = Config.select_options[i];
      _order.foodOrders.add(_foodOrder);
    }
    _order.add_more_information = Config.add_more_information;
    print(_order.add_more_information);
    orderRepo.addOrder(_order, this.payment).then((value) {
      if (value is Order) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).payment_card_updated_successfully),
      ));
    });
  }
}
