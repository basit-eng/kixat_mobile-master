import 'package:softify/model/FileDownloadResponse.dart';
import 'package:softify/model/OrderDetailsResponse.dart';
import 'package:softify/model/OrderHistoryResponse.dart';
import 'package:softify/model/SampleDownloadResponse.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';
import 'package:softify/utils/AppConstants.dart';
import 'package:softify/utils/FileResponse.dart';
import 'package:softify/utils/utility.dart';

class OrderRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<OrderHistoryResponse> fetchOrderHistory() async {
    final response = await _helper.get(Endpoints.orderHistory);
    return OrderHistoryResponse.fromJson(response);
  }

  Future<OrderDetailsResponse> fetchOrderDetails(num orderId) async {
    final response = await _helper.get('${Endpoints.orderDetails}/$orderId');
    return OrderDetailsResponse.fromJson(response);
  }

  Future<String> reorder(num orderId) async {
    final response = await _helper.get('${Endpoints.reorder}/$orderId');
    return response.toString();
  }

  Future<String> repostPayment(num orderId) async {
    final response = await _helper.post(
        '${Endpoints.orderRepostPayment}/$orderId',
        AppConstants.EMPTY_POST_BODY);
    return response.toString();
  }

  Future<FileDownloadResponse> downloadPdfInvoice(num orderId) async {
    final FileResponse response =
        await _helper.getFile('${Endpoints.orderPdfInvoice}/$orderId');

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

  Future<FileDownloadResponse> downloadNotesAttachment(int noteId) async {
    final FileResponse response =
        await _helper.getFile('${Endpoints.orderNote}/$noteId');

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
