import '../helpers/custom_trace.dart';
import '../models/category.dart';
import '../models/extra.dart';
import '../models/extra_group.dart';
import '../models/media.dart';
import '../models/nutrition.dart';
import '../models/restaurant.dart';
import '../models/review.dart';

class Food {
  String id;
  String name;
  double price;
  double discountPrice;
  Media image;
  String description;
  String ingredients;
  String weight;
  String unit;
  String packageItemsCount;
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String option5;
  String option6;
  String option7;
  String option8;
  String option9;
  String option10;
  String option11;
  String option12;
  String option13;
  String option14;
  String option15;
  bool featured;
  bool deliverable;
  Restaurant restaurant;
  Category category;
  List<Extra> extras;
  List<ExtraGroup> extraGroups;
  List<Review> foodReviews;
  List<Nutrition> nutritions;

  Food();

  Food.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      discountPrice = jsonMap['discount_price'] != null ? jsonMap['discount_price'].toDouble() : 0.0;
      price = discountPrice != 0 ? discountPrice : price;
      discountPrice = discountPrice == 0 ? discountPrice : jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      description = jsonMap['description'];
      ingredients = jsonMap['ingredients'];
      weight = jsonMap['weight'] != null ? jsonMap['weight'].toString() : '';
      unit = jsonMap['unit'] != null ? jsonMap['unit'].toString() : '';
      packageItemsCount = jsonMap['package_items_count'].toString();
      question = jsonMap['question'] != null ? jsonMap['question'].toString() : '';
      option1 = jsonMap['option1'] != null ? jsonMap['option1'].toString() : '';
      option2 = jsonMap['option2'] != null ? jsonMap['option2'].toString() : '';
      option3 = jsonMap['option3'] != null ? jsonMap['option3'].toString() : '';
      option4 = jsonMap['option4'] != null ? jsonMap['option4'].toString() : '';
      option1 = jsonMap['option5'] != null ? jsonMap['option5'].toString() : '';
      option2 = jsonMap['option6'] != null ? jsonMap['option6'].toString() : '';
      option3 = jsonMap['option7'] != null ? jsonMap['option7'].toString() : '';
      option4 = jsonMap['option8'] != null ? jsonMap['option8'].toString() : '';
      option1 = jsonMap['option9'] != null ? jsonMap['option9'].toString() : '';
      option2 = jsonMap['option10'] != null ? jsonMap['option10'].toString() : '';
      option3 = jsonMap['option11'] != null ? jsonMap['option11'].toString() : '';
      option4 = jsonMap['option12'] != null ? jsonMap['option12'].toString() : '';
      option2 = jsonMap['option13'] != null ? jsonMap['option13'].toString() : '';
      option3 = jsonMap['option14'] != null ? jsonMap['option14'].toString() : '';
      option4 = jsonMap['option15'] != null ? jsonMap['option15'].toString() : '';
      featured = jsonMap['featured'] ?? false;
      deliverable = jsonMap['deliverable'] ?? false;
      restaurant = jsonMap['restaurant'] != null ? Restaurant.fromJSON(jsonMap['restaurant']) : Restaurant.fromJSON({});
      category = jsonMap['category'] != null ? Category.fromJSON(jsonMap['category']) : Category.fromJSON({});
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
      extras = jsonMap['extras'] != null && (jsonMap['extras'] as List).length > 0
          ? List.from(jsonMap['extras']).map((element) => Extra.fromJSON(element)).toSet().toList()
          : [];
      extraGroups = jsonMap['extra_groups'] != null && (jsonMap['extra_groups'] as List).length > 0
          ? List.from(jsonMap['extra_groups']).map((element) => ExtraGroup.fromJSON(element)).toSet().toList()
          : [];
      foodReviews = jsonMap['food_reviews'] != null && (jsonMap['food_reviews'] as List).length > 0
          ? List.from(jsonMap['food_reviews']).map((element) => Review.fromJSON(element)).toSet().toList()
          : [];
      nutritions = jsonMap['nutrition'] != null && (jsonMap['nutrition'] as List).length > 0
          ? List.from(jsonMap['nutrition']).map((element) => Nutrition.fromJSON(element)).toSet().toList()
          : [];
    } catch (e) {
      id = '';
      name = '';
      price = 0.0;
      discountPrice = 0.0;
      description = '';
      weight = '';
      ingredients = '';
      unit = '';
      packageItemsCount = '';
      featured = false;
      deliverable = false;
      restaurant = Restaurant.fromJSON({});
      category = Category.fromJSON({});
      image = new Media();
      extras = [];
      extraGroups = [];
      foodReviews = [];
      nutritions = [];
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["description"] = description;
    map["ingredients"] = ingredients;
    map["weight"] = weight;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
