
import 'package:kixat/model/DownloadableProductResponse.dart';
import 'package:kixat/model/FileDownloadResponse.dart';
import 'package:kixat/model/SampleDownloadResponse.dart';
import 'package:kixat/model/UserAgreementResponse.dart';
import 'package:kixat/networking/ApiBaseHelper.dart';
import 'package:kixat/networking/Endpoints.dart';
import 'package:kixat/utils/FileResponse.dart';
import 'package:kixat/utils/utility.dart';

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
    final FileResponse response = await _helper.getFile('${Endpoints.getDownload}/$guid/$consent');

    if(response.isFile) {
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