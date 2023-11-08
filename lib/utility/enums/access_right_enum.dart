 enum AppAccessRightEnum {
  noAccessRights(0),
  mluOnlyOrMdAssociateOrAssociateOrLevel1OrLookup(1),
  mdAssociateOrCoordinatorOrLevel2(2),
  coordinatorOrLpStoreDetective(3),
  lpStoreDetectiveOrWebAccess(5),
  managerOrFullAccessRights(8),
  specialAccessRights(9);

  final int rawValue;
  const AppAccessRightEnum(this.rawValue);
}