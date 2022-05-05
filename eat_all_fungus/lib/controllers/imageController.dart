import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/services/imageRepository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final playerExceptionProvider = StateProvider<CustomException?>((_) => null);

final imageControllerProvider =
    StateNotifierProvider<ImageController, AsyncValue<Map<String, Image>>>(
        (ref) {
  return ImageController(ref.read);
});

class ImageController extends StateNotifier<AsyncValue<Map<String, Image>>> {
  final Reader _read;
  final Map<String, Image> _images = {};

  ImageController(this._read) : super(AsyncValue.loading()) {
    state = AsyncValue.data(_images);
  }

  Future<Image> getImage(String imageName) async {
    if (!_images.containsKey(imageName)) {
      _images[imageName] = Image.network(
        await _read(imageRepository)
                .getItemImageUrl(itemImageName: imageName) ??
            "",
        filterQuality: FilterQuality.none,
        fit: BoxFit.contain,
      );
    }
    return Future.value(_images[imageName]);
  }
}
