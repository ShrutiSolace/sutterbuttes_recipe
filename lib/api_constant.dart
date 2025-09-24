class ApiConstants
{
  static  String baseUrl = 'https://staging.sutterbuttesoliveoil.com/wp-json';

 ///--WooCommerce CK,CS API Keys --///
  static String consumerKey = 'ck_90684e6eb6fb54af4cb32db19d1ed0bf4052e8d9';
  static String consumerSecret = 'cs_5c94e92e6481648776a3af56f0ce416d3f9a8a40';




  ///--Authentication API --///
  static String loginUrl = '$baseUrl/jwt-auth/v1/token';
  static String signUpUrl = '$baseUrl/sbo/v1/signup';
  static String refreshTokenUrl = '$baseUrl/jwt-auth/v1/token/refresh';
  static String validateTokenUrl = '$baseUrl/jwt-auth/v1/token/validate';

  ///--Listing recipes--///
 static String recipesListUrl = '$baseUrl/wp/v2/recipes';
 static String recipesCategoryListUrl = '$baseUrl/sbo/v1/recipe-categories';
 static String trendingRecipesUrl = '$baseUrl/sbo/v1/trending-recipes';


 ///Product List ///
 static String productListUrl = '$baseUrl/wc/v3/products';
 static String productdetailUrl = '$baseUrl/wc/v3/products/'; // Append product ID for details

///Favourites ///
static String favouritesUrl = '$baseUrl/sbo/v1/favorites';

///profile //
  static String profileUrl = '$baseUrl/sbo/v1/get-profile';
  static String updateProfileUrl = '$baseUrl/sbo/v1/update-profile';
  static String changePasswordUrl = '$baseUrl/sbo/v1/change-password';



///----Newletter Subscription--//
  static String newsletterUrl = '$baseUrl/sbo/v1/newsletter';
  static String subscriberUrl = '$baseUrl/sbo/v1/newsletter/subscribe';
  static String unsubscribeUrl = '$baseUrl/sbo/v1/newsletter/unsubscribe';

  

}
