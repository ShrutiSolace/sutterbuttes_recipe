class ApiConstants
{
  static  String baseUrl = 'https://staging.sutterbuttesoliveoil.com/wp-json';

  ///--Authentication API --///
  static String loginUrl = '$baseUrl/jwt-auth/v1/token';
  static String signUpUrl = '$baseUrl/sbo/v1/signup';
  static String refreshTokenUrl = '$baseUrl/jwt-auth/v1/token/refresh';
  static String validateTokenUrl = '$baseUrl/jwt-auth/v1/token/validate';

  ///--Listing recipes--///
 static String recipesListUrl = '$baseUrl/wp/v2/recipes';

 static String recipesCategoryListUrl = '$baseUrl/sbo/v1/recipe-categories';

}