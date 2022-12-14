import 'package:get/get.dart';

class TranslationsFile extends Translations {
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // Driver Fragments
          'noDriverFound': 'No Driver Found',
          'orderAssign': 'Order Assign To Driver Successfully',
          'orderOnTheWayTitle': 'Order OnTheWay',
          'trackOrderBody': 'Your order assigned to driver track your order this id',
          // Home Fragments => App Settings Fragment
          'appSettings': 'Restaurant Settings',
          'restaurantDetails': 'Restaurant Details',
          'deliveryCharges': 'Delivery Charges',
          'appVersion': 'App Version',
          'logout': 'Logout',
          'confirmation': 'Confirmation',
          'wantLogout': 'Do you want to logout?',
          'no': 'No',
          'yes': 'Yes',
          // Home Fragments => Menu Fragment
          'menu': 'Menu',
          'categories': 'Categories',
          'items': 'Items',
          'deals': 'Deals',
          // Home Fragments => Notify Customer Fragment
          'notifyCustomer': 'Notify Customer',
          'enterTitle': 'Enter Title',
          'title': 'Title',
          'pleaseEnterTitle': 'Please Enter Title',
          'enterMessage': 'Enter Message',
          'message': 'Message',
          'pleaseEnterMessage': 'Please Enter Message',
          'send': 'Send',
          'noUserFound': 'No Users Found',
          'notificationSent': 'Notification Sent Successfully',
          // Home Fragments => Orders Fragment
          'orders': 'Orders',
          'pending': 'Pending',
          'accepted': 'Accepted',
          'preparing': 'Preparing',
          'onTheWay': 'OnTheWay',
          'delivered': 'Delivered',
          'cancelled': 'Cancelled',
          // Home Fragments => Sales Fragment
          'sales': 'Sales',
          'itemSales': 'Item Sales',
          'dealSales': 'Deals Sales',
          // Orders Fragments => Accepted Orders Fragment
          'noOrders':'No Orders Found',
          'orderStarted':'Order Start Preparing Successfully',
          'orderStartTitle':'Order Start Preparing',
          'orderStartBody':'Your order started preparing of this id',
          // Orders Fragments => Pending Orders Fragment
          'orderAccepted':'Order Accepted Successfully',
          'orderRejected':'Order Rejected Successfully',
          'orderAcceptedTitle':'Order Accepted',
          'orderRejectedTitle':'Order Rejected',
          'orderAcceptedBody':'Your order has been accepted of this id',
          'orderRejectedBody':'Your order has been rejected of this id',
          // Add Category Screen
          'addNewCategory':'Add New Category',
          'editCategory':'Edit Category',
          'uploadImage':'Upload Image',
          'image':'Image',
          'uploadIcon':'Upload Icon',
          'icon':'Icon',
          'enterName':'Enter Name',
          'name':'Name',
          'pleaseEnterCategoryName':'Please Enter Category Name',
          'selectColor':'Select Color',
          'color':'Color',
          'pleaseChooseColor':'Please Choose Color',
          'pleaseSelectCategoryIcon':'Please Select Category Icon',
          'pleaseSelectCategoryImage':'Please Select Category Image',
          'save':'Save',
          'dataUpdated':'Data Updated Successfully',
          'needAllow':'You need to allow permission in order to continue',
          // Add Deal Screen
          'addNewDeal':'Add New Deal',
          'editDeal':'Edit Deal',
          'pleaseEnterDealName':'Please Enter Deal Name',
          'enterNewPrice':'Enter New Price',
          'newPrice':'New Price',
          'pleaseEnterDealNewPrice':'Please Enter Deal New Price',
          'enterOldPrice':'Enter Old Price',
          'oldPrice':'Old Price',
          'pleaseEnterDealOldPrice':'Please Enter Deal Old Price',
          'enterDiscount':'Enter Discount',
          'discount':'Discount',
          'pleaseEnterDealDiscount':'Please Enter Deal Discount',
          'enterNoOfServing':'Enter No of Serving',
          'serving':'Serving',
          'pleaseEnterNoOfServing':'Please Enter No of Serving',
          'selectStartDate':'Select Start Date',
          'startDate':'Start Date',
          'selectEndDate':'Select End Date',
          'endDate':'End Date',
          'pleaseSelectDate':'Please Select Date',
          'enterDetails':'Enter Details',
          'details':'Details',
          'pleaseEnterDetails':'Please Enter Details',
          'productHasDrinks':'Does this product has drinks',
          'addDrinks':'Add Drinks',
          'enterDrink':'Enter Drink',
          'drink':'Drink',
          'productHasFlavour':'Does this product has flavour',
          'addFlavours':'Add Flavours',
          'enterFlavour':'Enter Flavour',
          'flavour':'Flavour',
          'productHasItems':'Does this product has items included',
          'addItems':'Add Items',
          'enterItem':'Enter Item',
          'itemIncluded':'Item Included',
          'selectDealImage':'Please Select Deal Image',
          'addProductFlavour':'Please Add Product Flavour',
          'addDealDrinks':'Please Add Deal Drinks',
          'addDealItemIncluded':'Please Add Deal Item Included',
          'deleteProduct':'Do you want to delete this product?',
          'productDeleted':'Product Deleted Successfully',
          // Add Drinks Screen
          'addDrinksHeading':'Add Drinks',
          'provideDrinkTitle':'Please Provide Drink Title',
          'addMoreDrinks':'Add more',
          'selectDrinks':'Select',
          // Add Flavours Screen
          'addFlavoursHeading':'Add Flavours',
          'provideFlavourTitle':'Please Provide Flavour Title',
          'addMoreFlavour':'Add more',
          'selectFlavour':'Select',
          // Add Ingredients Screen
          'addIngredientsHeading':'Add Ingredients',
          'provideIngredientsTitle':'Please Provide Ingredients Title',
          'addMoreIngredients':'Add more',
          'selectIngredients':'Select',
          // Add Items Included Screen
          'addItemsIncludedHeading':'Add Items Included',
          'provideItemsIncludedTitle':'Please Provide Items Included Title',
          'addMoreItemsIncluded':'Add more',
          'selectItemsIncluded':'Select',
          // Add Product Screen
          'addNewItem':'Add New Item',
          'editItem':'Edit Item',
          'uploadItemImage':'Upload Image',
          'chooseCategory':'Choose Category',
          'enterItemName':'Enter Name',
          'itemName':'Name',
          'enterProductName':'Please Enter Product Name',
          'enterItemPrice':'Enter Price',
          'itemPrice':'Price',
          'pleaseEnterItemPrice':'Please Enter Product Price',
          'enterNoOfItemServing':'Enter No of Serving',
          'itemServing':'Serving',
          'pleaseEnterNoOfItemServing':'Please Enter No of Serving',
          'enterItemDetails':'Enter Details',
          'itemDetails':'Details',
          'pleaseEnterItemDetails':'Please Enter Details',
          'itemHasFlavour':'Does this product has flavour',
          'addItemFlavour':'Add Flavours',
          'enterItemFlavour':'Enter Flavour',
          'itemFlavour':'Flavour',
          'itemHasVariations':'Does this product has variations',
          'addItemVariations':'Add Variations',
          'enterVariationsTitle':'Enter Title',
          'variationsTitle':'Title',
          'enterVariationsPrice':'Enter Price',
          'variationsPrice':'Price',
          'itemHasIngredients':'Does this product has ingredients',
          'addItemIngredients':'Add Ingredients',
          'enterItemIngredients':'Enter Ingredient',
          'itemIngredients':'Ingredient',
          'selectCategory':'Please Select Category',
          'selectItemImage':'Please Select Product Image',
          'saveItem':'Save',
          'pleaseAddItemFlavour':'Please Add Product Flavour',
          'pleaseAddItemVariations':'Please Add Product Variations',
          'pleaseAddItemIngredients':'Please Add Product Ingredients',
          // Add Variations Screen
          'addVariationsHeading':'Add Variations',
          'provideVariationTitle':'Please Provide Variation Title',
          'provideVariationPrice':'Please Provide Variation Price',
          'addMoreVariation':'Add more',
          'selectVariation':'Select',
          // Categories Screen
          'allCategories':'All Categories',
          'noCategories':'No Categories Found',
          // Delivery Charges Screen
          'deliveryChargesHeading':'Delivery Charges',
          'editDeliveryCharges':'Edit delivery charges',
          'chargesFeePerKm':'Charges Fee Per KM',
          'charges':'Charges',
          'enterChargesFee':'Please Enter Charges Fee',
          'freeDeliveryRadius':'Free Delivery Radius',
          'radius':'Radius',
          'enterDeliveryRadius':'Please Enter Free Delivery Radius',
          'maxRadius':'Max Radius',
          'taxesAvg':'Taxes (%)',
          'taxes':'Taxes',
          'enterTaxes':'Please Enter Taxes',
          'update':'Update',
          'noData':'No Data Found',
          // Home Screen
          'wantExit': 'Do you want to exit?',
          'restaurantName':'Restaurant Name',
          'restaurantNumber':'Restaurant Number',
          'navOrders':'Orders',
          'navSales':'Sales',
          'navMenu':'Menu',
          'navNotifyCustomer':'Notify Customer',
          'navAppSettings':'Restaurant Settings',
        }
      };
}
