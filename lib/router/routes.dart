class Routes {
  Routes._();
  // auth (outside shell)
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const verify = '/verify';
  static const forgot = '/forgot';
  static const welcome = '/welcome';
  // shell tabs
  static const home = '/home';
  static const profile = '/profile';
  static const settings = '/settings';
  // pushed flows
  static const warehouses = '/warehouses';
  static const lockers = '/lockers';
  static const lockersCountry = '/lockers/:code';
  static const createShipment = '/shipments/new';
  static const orders = '/orders';
  static const orderDetail = '/orders/:id';
  static const trackOrder = '/orders/:id/track';
  static const plans = '/plans';
  static const planDetail = '/plans/:code';     // basic|smart|prime
  static const payment = '/payment';            // query: ?for=plan_<code>
  static const paymentSuccess = '/payment/success';
  static const paymentError = '/payment/error';
  static const howItWorks = '/how-it-works';
  static const support = '/support';
  static const about = '/about';
  static const policy = '/policy';
  static const editProfile = '/profile/edit';
  static const changePassword = '/profile/password';
  static const settingsLanguage = '/settings/language';
  static const settingsCurrency = '/settings/currency';
  static const calculator = '/calculator';
  static const myAddress = '/my-address';
  static const confirmOrder = '/orders/:id/confirm';
}
