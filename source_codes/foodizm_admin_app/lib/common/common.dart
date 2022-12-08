import 'package:foodizm_admin_app/database_model/categories_model.dart';
import 'package:foodizm_admin_app/database_model/charges_model.dart';
import 'package:foodizm_admin_app/database_model/deals_model.dart';
import 'package:foodizm_admin_app/database_model/driver_model.dart';
import 'package:foodizm_admin_app/database_model/order_model.dart';
import 'package:foodizm_admin_app/database_model/product_model.dart';
import 'package:foodizm_admin_app/database_model/restaurant_details_model.dart';
import 'package:get/get.dart';

class Common {
  static String dummyText = 'It is a long established fact that a reader will be distracted by the readable content '
      'of a page when looking at its layout';

  static String ingredientsText = '2 cups cold milk, '
      '2 cups sliced fresh strawberries, divided, 2 medium peach or nectarines, peeled and sliced';

  static String name = 'Home';
  static String currency = '\$';
  static String apiKey = 'Your Api Key';

  static RxList<dynamic> selectedDrinksList = [].obs;
  static RxList<dynamic> selectedFlavourList = [].obs;
  static RxList<dynamic> selectedItemIncludedList = [].obs;
  static RxList<dynamic> selectedIngredientsList = [].obs;
  static RxList<dynamic> selectedVariationsList = [].obs;

  static RxList<CategoriesModel> categoriesList = <CategoriesModel>[].obs;
  static RxList<DealsModel> dealsList = <DealsModel>[].obs;
  static RxList<ProductModel> productList = <ProductModel>[].obs;
  static Rx<RestaurantDetailsModel> restaurantDetails = new RestaurantDetailsModel().obs;
  static Rx<ChargesModel> chargesModel = new ChargesModel().obs;

  static RxList<OrderModel> pendingOrderModel = <OrderModel>[].obs;
  static RxList<OrderModel> acceptedOrderModel = <OrderModel>[].obs;
  static RxList<OrderModel> preparingOrderModel = <OrderModel>[].obs;
  static RxList<OrderModel> onTheWayOrderModel = <OrderModel>[].obs;
  static RxList<OrderModel> deliveredOrderModel = <OrderModel>[].obs;
  static RxList<OrderModel> cancelledOrderModel = <OrderModel>[].obs;

  static RxString monGraph = '0'.obs;
  static RxString tueGraph ='0'.obs;
  static RxString wedGraph ='0'.obs;
  static RxString thuGraph = '0'.obs;
  static RxString friGraph = '0'.obs;
  static RxString satGraph = '0'.obs;
  static RxString sunGraph = '0'.obs;

  static RxList<DealsModel> totalDealsOrder = <DealsModel>[].obs;
  static RxList<ProductModel> totalItemOrder = <ProductModel>[].obs;

  static RxList<DriverModel> freeDriverModel = <DriverModel>[].obs;
  static RxList<DriverModel> busyDriverModel = <DriverModel>[].obs;
}
