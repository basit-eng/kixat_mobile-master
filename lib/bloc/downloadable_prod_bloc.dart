import 'dart:async';

import 'package:kixat/bloc/base_bloc.dart';
import 'package:kixat/model/DownloadableProductResponse.dart';
import 'package:kixat/model/FileDownloadResponse.dart';
import 'package:kixat/model/SampleDownloadResponse.dart';
import 'package:kixat/model/UserAgreementResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/repository/DownloadableProdRepository.dart';

class DownloadableProductBloc extends BaseBloc {
  DownloadableProdRepository _repository;
  StreamController _scProduct, _scSampleDownload, _scAgreement;

  StreamSink<ApiResponse<DownloadableProductData>> get productSink =>
      _scProduct.sink;
  Stream<ApiResponse<DownloadableProductData>> get productStream =>
      _scProduct.stream;

  StreamSink<ApiResponse<UserAgreementData>> get agreementSink => _scAgreement.sink;
  Stream<ApiResponse<UserAgreementData>> get agreementStream => _scAgreement.stream;

  StreamSink<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>> get sampleDownloadSink =>
      _scSampleDownload.sink;
  Stream<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>> get sampleDownloadStream =>
      _scSampleDownload.stream;

  DownloadableProductBloc() {
    _repository = DownloadableProdRepository();
    _scProduct = StreamController<ApiResponse<DownloadableProductData>>();
    _scAgreement = StreamController<ApiResponse<UserAgreementData>>();
    _scSampleDownload = StreamController<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>>();
  }

  @override
  void dispose() {
    _scProduct?.close();
    _scSampleDownload?.close();
    _scAgreement?.close();
  }

  fetchDownloadableProducts() async {
    productSink.add(ApiResponse.loading());

    try {
      DownloadableProductResponse response = await _repository.fetchDownloadableProducts();
      productSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      productSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchUserAgreementText(String guid) async {
    agreementSink.add(ApiResponse.loading());

    try {
      UserAgreementResponse response = await _repository.fetchUserAgreementText(guid);
      agreementSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      agreementSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  void downloadFile(String guid, String consent) async {
    sampleDownloadSink.add(ApiResponse.loading());

    try {
      FileDownloadResponse<SampleDownloadResponse> response = await _repository.downloadFile(
          guid, consent,
      );

      if(response.jsonResponse?.data?.hasUserAgreement == true)
        fetchUserAgreementText(guid);
      else
        sampleDownloadSink.add(ApiResponse.completed(response));
    } catch (e) {
      sampleDownloadSink.add(ApiResponse.error(e.toString()));
      print(e.toString());
    }
  }

}