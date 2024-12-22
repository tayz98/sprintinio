/// Enum for the permission to create tickets
enum ManageIssuesPermission {
  everyone,
  onlyHost,
}

/// Extension to convert the enum to string used in the UI
extension ManageIssuesPermissionNameExtension on ManageIssuesPermission {
  String get name {
    switch (this) {
      case ManageIssuesPermission.everyone:
        return 'All players';
      case ManageIssuesPermission.onlyHost:
        return 'Only Host';
      default:
        return 'Unknown permission';
    }
  }
}

extension ManageIssuesPermissionStringExtension on ManageIssuesPermission {
  String get string {
    switch (this) {
      case ManageIssuesPermission.everyone:
        return 'everyone';
      case ManageIssuesPermission.onlyHost:
        return 'onlyHost';
      default:
        return '';
    }
  }
}
