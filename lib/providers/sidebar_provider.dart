import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sprintinio/util/enums.dart';

part 'sidebar_provider.g.dart';

@riverpod
class Sidebar extends _$Sidebar {
  SidebarType sidebarType = SidebarType.none;

  @override
  bool build() {
    return false;
  }

  void openSidebar(SidebarType sidebarType, {bool condition = true}) {
    final currentSidebarType = this.sidebarType;
    final isSidebarVisible = state;

    if (currentSidebarType == sidebarType && isSidebarVisible && condition) {
      return;
    }

    if (currentSidebarType == sidebarType && !isSidebarVisible && condition) {
      this.sidebarType = sidebarType;
      state = true;
      return;
    }

    _setStateToFalse();

    Future.delayed(const Duration(milliseconds: 300), () {
      this.sidebarType = sidebarType;
      state = true;
    });
  }

  void closeSidebar() {
    sidebarType = SidebarType.none;
    state = false;
  }

  void _setStateToFalse() {
    state = false;
  }
}
