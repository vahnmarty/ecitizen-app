import 'package:citizen/helpers/session_helper.dart';
import 'package:citizen/models/service_model.dart';
import 'package:flutter/cupertino.dart';

import '../api/api.dart';
import '../api/api_service.dart';
import '../models/report_model.dart';

class ServicesProvider with ChangeNotifier {
  bool _isLoading = false;
  List<ServiceModel> _services = [];
  List<ReportModel> _myReports=[];
  BusinessServiceModel _businessServiceModel = BusinessServiceModel();

  BusinessServiceModel get businessServiceModel => _businessServiceModel;

  set businessServiceModel(BusinessServiceModel value) {
    _businessServiceModel = value;
    notifyListeners();
  }

  List<ReportModel> get myReports => _myReports;

  set myReports(List<ReportModel> value) {
    _myReports = value;
    notifyListeners();
  }

  List<ServiceModel> get services => _services;

  set services(List<ServiceModel> value) {
    _services = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  getServices() async {
    isLoading = true;
    List<ServiceModel> list = [];
    final response = await ApiService().getRequest('${Apis.services}');
    if (response != null && response != '') {
      for (var i = 0; i < response.length; i++) {
        list.add(ServiceModel.fromJson(response[i]));
      }
      services = list;
    }
    isLoading = false;
  }
  reportEmergency(dynamic data,String token,bool withImage)async{
    bool result=false;
      isLoading=true;
      dynamic response;
      if(withImage){
        debugPrint('with image');
        response =await ApiService().multipartPostRequest(Apis.reportEmergency, data, token);
      }else{
        debugPrint('no image');
        response =await ApiService().postRequest(Apis.reportEmergency, data,token: token);
      }
      debugPrint('res0: $response');
      if(response == null || response =='null'){
        result=false;
      }
      if(response !=null || response !=''){
        result=true;
      }else{
        result=false;
      }
      isLoading=false;
      return result;
  }
  getMyReports()async{
    _isLoading=true;
    List<ReportModel> list =[];
    final token = await getToken();
    final response = await ApiService().getRequest(Apis.report,token: token);
    if(response !=null){
      for(var i=0;i<response.length;i++){
        list.add(ReportModel.fromJson(response[i]));
      }
      myReports=list;
    }
    _isLoading=false;
  }
  gettingBusinessServiceModel(String id)async{
    isLoading=true;
    final response =await ApiService().getRequest('${Apis.services}/$id');
    if(response !=null){
      businessServiceModel = BusinessServiceModel.fromJson(response);
    }
    isLoading=false;
  }
}
