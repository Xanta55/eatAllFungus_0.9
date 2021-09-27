import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final imageRepository =
    Provider<ImageRepository>((ref) => ImageRepository(ref.read));

class ImageRepository {
  final Reader _read;

  const ImageRepository(this._read);

  Future<String?> getItemImageUrl({required String itemImageName}) async {
    return await getImageUrl(imagePath: 'items/$itemImageName.png');
  }

  Future<String?> getStatusImageUrl({required String statusImageName}) async {
    return await getImageUrl(imagePath: 'effects/$statusImageName.png');
  }

  Future<String?> getImageUrl({required String imagePath}) async {
    try {
      final url =
          await _read(fireStoreProvider)?.ref(imagePath).getDownloadURL();
      return url;
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
