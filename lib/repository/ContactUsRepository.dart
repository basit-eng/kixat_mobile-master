import 'package:kixat/model/ContactUsResponse.dart';
import 'package:kixat/networking/ApiBaseHelper.dart';
import 'package:kixat/networking/Endpoints.dart';

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