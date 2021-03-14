import 'package:flutter/material.dart';

class DashboardItemActions {
  final String name;
  final Icon icon;

  DashboardItemActions({
    @required this.name,
    @required this.icon,
  });
}

List<DashboardItemActions> dashboardItemActions = <DashboardItemActions>[
  DashboardItemActions(icon: Icon(Icons.edit), name: "Update"),
  DashboardItemActions(icon: Icon(Icons.delete), name: "Delete"),
];
