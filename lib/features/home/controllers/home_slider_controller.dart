// import 'package:crafty_bay/app/app_urls.dart';
// import 'package:crafty_bay/core/network_caller/network_caller.dart';
// import 'package:get/get.dart';
// import '../../data/home/model/slide_model.dart';
//
// class HomeSliderController extends GetxController {
//   bool _getSliderInProgress = false;
//   String? _errorMessage;
//
//   String? get errorMessage => _errorMessage;
//
//   List<SliderModel> _sliderList = [];
//   List<SliderModel> get sliders => _sliderList;
//   bool get getSliderInProgress => _getSliderInProgress;
//
//   Future<bool> getSlider() async {
//     bool isSuccess = false;
//     _getSliderInProgress = true;
//     update();
//     final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
//       url: AppUrls.slider,
//     );
//     if (response.isSuccess) {
//       List<SliderModel> list = [];
//
//       for (Map<String, dynamic> data
//       in response.responseData?['data']['results'] ?? []) {
//         list.add(SliderModel.fromJson(data));
//       }
//       _sliderList = list;
//       isSuccess = true;
//       _errorMessage = null;
//     } else {
//       _errorMessage = response.errorMessage;
//     }
//
//     _getSliderInProgress = false;
//     update();
//     return isSuccess;
//   }
// }
