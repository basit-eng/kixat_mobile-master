import 'package:schoolapp/model/ContactUsResponse.dart';
import 'package:schoolapp/networking/ApiBaseHelper.dart';
import 'package:schoolapp/networking/Endpoints.dart';

class ContactUsRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ContactUsResponse> fetchFormData() async {
    final response = await _helper.get(Endpoints.contactUs);
    return ContactUsResponse.fromJson(response);
  }

  Future<ContactUsResponse> postEnquiry(ContactUsResponse reqBody) async {
    final response = await _helper.post(Endpoints.contactUs, reqBody);
    return ContactUsResponse.fromJson(response);
  }
}
