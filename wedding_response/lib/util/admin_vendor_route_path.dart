class AdminVendorRoutePath {
  final String adminID;
  final String vendorID;
  final bool isUnknown;
  final bool isAdd;
  final bool isHome;
  


  AdminVendorRoutePath.inputDetails(this.adminID, this.vendorID) : isUnknown = false, isAdd = false, isHome = false;
  AdminVendorRoutePath.login()
      : adminID = null,
        vendorID = null,
        isUnknown = false,
        isHome = false,
        isAdd= false;
  AdminVendorRoutePath.allVendor(this.adminID)
      :vendorID = null,
        isUnknown = false,
        isHome = false,
        isAdd= false;
  AdminVendorRoutePath.unknown()
      : adminID = null,
        vendorID = null,
        isUnknown = true,
        isHome = false,
        isAdd= false;

  AdminVendorRoutePath.add(this.adminID)
      : vendorID = null,
        isUnknown = false,
        isHome = false,
        isAdd= true;

  AdminVendorRoutePath.home(this.adminID)
      : vendorID = null,
        isUnknown = false,
        isHome = true,
        isAdd= false;

  bool get isAddPage => adminID != null && vendorID == null && isAdd == true;
  bool get isLoginPage => adminID == null && vendorID == null && isUnknown == false;
  bool get isHomePage => adminID != null && vendorID == null && isAdd == false && isHome == true;
  bool get isInputDetailsPage => adminID != null && vendorID != null;

  bool get isAllVendorPage => adminID != null && vendorID == null  && isAdd == false && isHome == false;
}