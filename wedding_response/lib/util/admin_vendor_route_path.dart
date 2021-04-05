class AdminVendorRoutePath {
  final String adminID;
  final String vendorID;
  final bool isUnknown;
  final bool isAdd;
  


  AdminVendorRoutePath.inputDetails(this.adminID, this.vendorID) : isUnknown = false, isAdd = false;
  AdminVendorRoutePath.login()
      : adminID = null,
        vendorID = null,
        isUnknown = false,
        isAdd= false;
  AdminVendorRoutePath.allVendor(this.adminID)
      :vendorID = null,
        isUnknown = false,
        isAdd= false;
  AdminVendorRoutePath.unknown()
      : adminID = null,
        vendorID = null,
        isUnknown = true,
        isAdd= false;

  AdminVendorRoutePath.add(this.adminID)
      : vendorID = null,
        isUnknown = false,
        isAdd= true;

  bool get isAddPage => adminID != null && vendorID == null && isAdd == true;
  bool get isLoginPage => adminID == null && vendorID == null && isUnknown == false;

  bool get isInputDetailsPage => adminID != null && vendorID != null;

  bool get isAllVendorPage => adminID != null && vendorID == null;
}