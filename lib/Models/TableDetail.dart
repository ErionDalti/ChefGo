import 'dart:ui';

class TableDetail {
  String tableId;
  Color color;
  String time;
  String items;
  int status;

  TableDetail(this.tableId, this.color, this.time, this.items, this.status);
  TableDetail.fromJson(Map<String, dynamic> json) {
    tableId = json['tableId'];
    time = json['time'];
    items = json['items'];
    status = json['status'];
  }
}

class TableDetailNew {
  String tableId;
  String tableName;
  Color color;
  String time;
  // ignore: non_constant_identifier_names
  String current_seats_used;
  // ignore: non_constant_identifier_names
  String max_seats;
  String status;

  TableDetailNew(this.tableId, this.color, this.time, this.current_seats_used,
      this.max_seats, this.status, this.tableName);

  TableDetailNew.fromJson(Map<String, dynamic> json) {
    tableId = json['TABLE_ID'];
    time = json['SINCE'];
    current_seats_used = json['CURRENT_SEATS_USED'];
    max_seats = json['MAX_SEATS'];
    status = json['STATUS'] == "in_use"
        ? "In Uso"
        : json['STATUS'] == "out_of_use"
            ? "Fuori Servizio"
            : json['STATUS'] == "reserved"
                ? "Riservato"
                : "Disponibile";
    tableName = json['TABLE_NAME'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TABLE_ID'] = this.tableId;
    data['SINCE'] = this.time;
    data['CURRENT_SEATS_USED'] = this.current_seats_used;
    data['MAX_SEATS'] = this.max_seats;
    data['STATUS'] = this.status == "In Uso"
        ? "in_use"
        : this.status == "Fuori Servizio"
            ? "out_of_use"
            : this.status == "Riservato"
                ? "Reserved"
                : "Available";
    data['TABLE_NAME'] = this.tableName;
    return data;
  }
}
