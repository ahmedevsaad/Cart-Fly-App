import 'website_ref.dart';

class Warehouse {
  const Warehouse({
    required this.code,
    required this.displayName,
    required this.bestFor,
    required this.whyBuyHere,
    required this.categoriesHeading,
    required this.categories,
    required this.sites,
  });

  final String code;
  final String displayName;
  final String bestFor;
  final List<String> whyBuyHere;
  final String categoriesHeading;
  final List<String> categories;
  final List<WebsiteRef> sites;
}
