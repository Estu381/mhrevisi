// This class provides static constants for API endpoints used in the application.
class ApiConnect {
  // The base URL for the API server.
  static const hostConnect = "https://fluttermobilegame.000webhostapp.com";

  // The complete base URL for connecting to the API.
  static const connectApi = "$hostConnect";

  // Endpoint to add a user.
  static const register = "$connectApi/register.php";
  static const login = "$connectApi/login.php";
  static const get = "$connectApi/get.php";
  static const add = "$connectApi/add.php";
  static const edit = "$connectApi/edit.php";
  static const delete = "$connectApi/delete.php";
}
