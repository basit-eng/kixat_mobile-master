import 'package:softify/model/DownloadableProductResponse.dart';
import 'package:softify/model/FileDownloadResponse.dart';
import 'package:softify/model/SampleDownloadResponse.dart';
import 'package:softify/model/UserAgreementResponse.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';
import 'package:softify/utils/FileResponse.dart';
import 'package:softify/utils/utility.dart';

class DownloadableProdRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<DownloadableProductResponse> fetchDownloadableProducts() async {
    final response = await _helper.get(Endpoints.downloadableProducts);
    return DownloadableProductResponse.fromJson(response);
  }

  Future<UserAgreementResponse> fetchUserAgreementText(String guid) async {
    final response = await _helper.get('${Endpoints.userAgreement}/$guid');
    return UserAgreementResponse.fromJson(response);
  }

  Future<FileDownloadResponse> downloadFile(String guid, String consent) async {
    final FileResponse response =
        await _helper.getFile('${Endpoints.getDownload}/$guid/$consent');

    if (response.isFile) {
      return FileDownloadResponse<SampleDownloadResponse>(
        file: await saveFileToDisk(response, showNotification: true),
      );
    } else {
      return FileDownloadResponse<SampleDownloadResponse>(
        jsonResponse: SampleDownloadResponse.fromJson(response.jsonStr),
      );
    }
  }
}
