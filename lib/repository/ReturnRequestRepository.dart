import 'package:schoolapp/model/FileDownloadResponse.dart';
import 'package:schoolapp/model/FileUploadResponse.dart';
import 'package:schoolapp/model/ReturnRequestHistoryResponse.dart';
import 'package:schoolapp/model/ReturnRequestResponse.dart';
import 'package:schoolapp/model/SampleDownloadResponse.dart';
import 'package:schoolapp/model/requestbody/ReturnRequestBody.dart';
import 'package:schoolapp/networking/ApiBaseHelper.dart';
import 'package:schoolapp/networking/Endpoints.dart';
import 'package:schoolapp/utils/FileResponse.dart';
import 'package:schoolapp/utils/utility.dart';

class ReturnRequestRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ReturnRequestResponse> fetchReturnRequestForm(num orderId) async {
    final response = await _helper.get('${Endpoints.returnRequest}/$orderId');
    return ReturnRequestResponse.fromJson(response);
  }

  Future<ReturnRequestResponse> postReturnRequestForm(
      num orderId, ReturnRequestBody reqBody) async {
    final response =
        await _helper.post('${Endpoints.returnRequest}/$orderId', reqBody);
    return ReturnRequestResponse.fromJson(response);
  }

  Future<FileUploadResponse> uploadFile(String filePath) async {
    final response = await _helper.multipart(
        '${Endpoints.uploadFileReturnRequest}', filePath);
    return FileUploadResponse.fromJson(response);
  }

  Future<ReturnReqHistoryResponse> fetchReturnRequestHistory() async {
    final response = await _helper.get(Endpoints.returnRequestHistory);
    return ReturnReqHistoryResponse.fromJson(response);
  }

  Future<FileDownloadResponse> downloadFile(String guid) async {
    final FileResponse response =
        await _helper.getFile('${Endpoints.returnRequestFileDownload}/$guid');

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
