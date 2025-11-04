class ApiConstants

{

  ///--Base URL --///
  static  String baseUrl = 'https://staging.sutterbuttesoliveoil.com/wp-json';

 ///--WooCommerce CK,CS API Keys --///
  static String consumerKey = 'ck_90684e6eb6fb54af4cb32db19d1ed0bf4052e8d9';
  static String consumerSecret = 'cs_5c94e92e6481648776a3af56f0ce416d3f9a8a40';

  ///--Authentication API --///
  static String loginUrl = '$baseUrl/jwt-auth/v1/token';
  static String signUpUrl = '$baseUrl/sbo/v1/signup';
  static String refreshTokenUrl = '$baseUrl/jwt-auth/v1/token/refresh';
  static String validateTokenUrl = '$baseUrl/jwt-auth/v1/token/validate';
  static String forgotPasswordUrl = '$baseUrl/sbo/v1/forgot-password';
  static String googleLoginUrl = "$baseUrl/sbo/v1/google-login";


  ///--Listing recipes--///
 static String recipesListUrl = '$baseUrl/wp/v2/recipes';
 static String recipesCategoryListUrl = '$baseUrl/sbo/v1/recipe-categories';
 static String trendingRecipesUrl = '$baseUrl/sbo/v1/trending-recipes';
 static String recipesByCategoryUrl = '$baseUrl/sbo/v1/recipes-by-category'; // Append category ID for specific category


 ///Product List ///
 static String productListUrl = '$baseUrl/wc/v3/products';
 static String productdetailUrl = '$baseUrl/wc/v3/products/';
 static String trendingProductsUrl =  '$baseUrl/sbo/v1/trending-products';

///Favourites ///
static String favouritesUrl = '$baseUrl/sbo/v1/favorites';

///Cart ///
static String cartAddUrl = '$baseUrl/sbo/v1/cart/add';
static String cartUrl = '$baseUrl/sbo/v1/cart';
static String cartUpdateUrl = '$baseUrl/sbo/v1/cart/update';
static String cartRemoveUrl = '$baseUrl/sbo/v1/cart/remove';
static String checkoutUrl = '$baseUrl/sbo/v1/checkout';

///profile //
  static String profileUrl = '$baseUrl/sbo/v1/get-profile';
  static String updateProfileUrl = '$baseUrl/sbo/v1/update-profile';
  static String changePasswordUrl = '$baseUrl/sbo/v1/change-password';
  static String uploadProfileImageUrl = '$baseUrl/sbo/v1/upload-profile-image';



///----Newletter Subscription--//
  static String newsletterUrl = '$baseUrl/sbo/v1/newsletter';
  static String subscriberUrl = '$baseUrl/sbo/v1/newsletter/subscribe';
  static String unsubscribeUrl = '$baseUrl/sbo/v1/newsletter/unsubscribe';

///---Orders-- ///
   static String ordersUrl = '$baseUrl/wc/v3/orders';
///new ordres api
  ///---Orders-- ///
  static String orderslistUrl = '$baseUrl/sbo/v1/orders';  // Update this line
  static String orderDetailUrl = '$baseUrl/sbo/v1/orders/';  // Add this line

/// '$baseUrl/wc/v3/orders';

///---Notifications ---///
static String notificationsUrl = '$baseUrl/sbo/v1/notifications';
static String notificationsUpdateUrl = '$baseUrl/sbo/v1/notifications/update';
static String notificationsResetUrl = '$baseUrl/sbo/v1/notifications/reset';
static String notificationslistUrl = '$baseUrl/sbo/v1/my-notifications';

 ///About us ///
  static String aboutUsUrl = '$baseUrl/sbo/v1/page-details?slug=about-us';

///search ///
  static String searchUrl = '$baseUrl/sbo/v1/search';

  ///---Payments (Stripe) ---///
  static String stripeCreateIntentUrl = '$baseUrl/sbo/v1/confirm-payment';


  ///notifications ///
  static String deviceRegisterUrl = '$baseUrl/sbo/v1/device/new';
  static String deviceUnregisterUrl = '$baseUrl/sbo/v1/device/remove';
}
