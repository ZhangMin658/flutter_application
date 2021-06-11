import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/elements/ResCategoriesCarouselItemWidget.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class ResCategoriesCarouselWidget extends StatelessWidget {
  List<Category> categories;
  String res_id;

  ResCategoriesCarouselWidget({Key key, this.categories, this.res_id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 150)
        : Container(
            height: 150,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              itemCount: this.categories.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                return new ResCategoriesCarouselItemWidget(
                  marginLeft: _marginLeft,
                  category: this.categories.elementAt(index),
                  res_id: res_id,
                );
              },
            ));
  }
}
