import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rahrisha_food/features/auth/controllers/user_service.dart';

class FavouritesController extends GetxController {
  final RxList<Map<String, dynamic>> _favouriteItems = <Map<String, dynamic>>[].obs;

  final GetStorage _storage = GetStorage();
  final UserService userService = Get.find<UserService>();

  RxList<Map<String, dynamic>> favoriteRecipes = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get favouriteItems => _favouriteItems.toList();

  String get _storageKey => 'favourites_${userService.userId.value}';

  void removeRecipeById(int id) {
    favoriteRecipes.removeWhere((recipe) => recipe['id'] == id);
  }

  void toggleFavourite(Map<String, dynamic> item) {
    final isAlreadyFavourite = _favouriteItems.any((favItem) =>
    favItem['id'] == item['id']);

    if (isAlreadyFavourite) {
      _favouriteItems.removeWhere((favItem) => favItem['id'] == item['id']);
      Get.snackbar('Removed', '${item['name']} removed from favourites.');
    } else {
      _favouriteItems.add(item);
      Get.snackbar('Added', '${item['name']} added to favourites!');
    }

    _saveFavourites();
  }

  bool isFavourite(Map<String, dynamic> item) {
    return _favouriteItems.any((favItem) => favItem['id'] == item['id']);
  }

  void _saveFavourites() {
    _storage.write(_storageKey, _favouriteItems);
  }

  void _loadFavourites() {
    final storedData = _storage.read<List>(_storageKey);
    if (storedData != null) {
      _favouriteItems.assignAll(List<Map<String, dynamic>>.from(storedData));
    }
  }

  void removeFavourite(Map<String, dynamic> item) {
    _favouriteItems.removeWhere((favItem) => favItem['id'] == item['id']);
    Get.snackbar('Removed', '${item['name']} removed from favourites.');
    _saveFavourites();
  }


  @override
  void onInit() {
    super.onInit();
    ever(userService.userId, (_) => _loadFavourites());
    _loadFavourites();
  }
}
