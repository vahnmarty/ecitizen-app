class HotlineCategores {
  int? policeStation;
  int? medicalAssistance;
  int? fireStation;
  int? localDisaster;
  int? trafficAssistance;
  int? redCross;
  int? localGovernment;

  HotlineCategores(
      {this.policeStation,
        this.medicalAssistance,
        this.fireStation,
        this.localDisaster,
        this.trafficAssistance,
        this.redCross,
        this.localGovernment});

  HotlineCategores.fromJson(Map<String, dynamic> json) {
    policeStation = json['PoliceStation'];
    medicalAssistance = json['MedicalAssistance'];
    fireStation = json['FireStation'];
    localDisaster = json['LocalDisaster'];
    trafficAssistance = json['TrafficAssistance'];
    redCross = json['RedCross'];
    localGovernment = json['LocalGovernment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PoliceStation'] = this.policeStation;
    data['MedicalAssistance'] = this.medicalAssistance;
    data['FireStation'] = this.fireStation;
    data['LocalDisaster'] = this.localDisaster;
    data['TrafficAssistance'] = this.trafficAssistance;
    data['RedCross'] = this.redCross;
    data['LocalGovernment'] = this.localGovernment;
    return data;
  }
}
