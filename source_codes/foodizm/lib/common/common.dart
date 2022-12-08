import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodizm/models/cart_model.dart';
import 'package:foodizm/models/categories_model.dart';
import 'package:foodizm/models/deals_model.dart';
import 'package:foodizm/models/order_model.dart';
import 'package:foodizm/models/product_model.dart';
import 'package:foodizm/models/user_model.dart';
import 'package:get/get.dart';

class Common {
  static String dummyText = 'It is a long established fact that a reader will be distracted by the readable content '
      'of a page when looking at its layout';

  static String ingredientsText = '2 cups cold milk, '
      '2 cups sliced fresh strawberries, divided, 2 medium peach or nectarines, peeled and sliced';

  static String name = 'Home';
  static String homeIndex = '0';
  static String currency = '\$';

  static String? cardNumber;
  static String? apiKey = "Your Api Key";

  static String? currentLat;
  static String? currentLng;
  static String? currentAddress;
  static String? currentCity;

  static String? selectedLat;
  static String? selectedLng;
  static String? selectedAddress;

  static String? codeSent;
  static int? resendToken;
  static PhoneAuthCredential? credential;

  static RxBool verified = false.obs;

  static UserModel userModel = new UserModel();
  static RxList<CategoriesModel> categoriesList = <CategoriesModel>[].obs;
  static RxList<CategoriesModel> allCategoriesList = <CategoriesModel>[].obs;
  static RxList<DealsModel> dealsList = <DealsModel>[].obs;
  static RxList<ProductModel> popularProductList = <ProductModel>[].obs;
  static RxList<ProductModel> latestProductList = <ProductModel>[].obs;
  static RxList<ProductModel> categoryProductList = <ProductModel>[].obs;
  static RxList<CartModel> cartModel = <CartModel>[].obs;
  static RxList<OrderModel> pendingOrderModel = <OrderModel>[].obs;
  static RxList<OrderModel> ongoingOrderModel = <OrderModel>[].obs;
  static RxList<OrderModel> deliveredOrderModel = <OrderModel>[].obs;
  static RxList<OrderModel> completedOrderModel = <OrderModel>[].obs;
  static RxList<OrderModel> cancelledOrderModel = <OrderModel>[].obs;
}
