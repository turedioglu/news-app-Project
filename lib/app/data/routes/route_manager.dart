class RouteManager {
  static final RouteManager _instace = RouteManager._init();
  static RouteManager get instance {
    return _instace;
  }

  RouteManager._init();

  String get newsDetail => "/newsDetail";
  String get home => "/home";
}
