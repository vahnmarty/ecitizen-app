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
        list.add(ServiceModel(id: '0',name: 'I want to apply for ...'));
        list.add(ServiceModel.fromJson(response[i]));
      }
      services = list;
    }
    isLoading = false;
  }
  reportEmergency(dynamic data,String token)async{
    bool result=false;
      isLoading=true;
      final response =await ApiService().postRequest(Apis.reportEmergency, data,token: token);
      debugPrint('res: $response');
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
}
