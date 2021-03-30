class AdminVendorRoutePath {
  final String adminID;
  final String vendorID;
  final bool isUnknown;
  final bool isDone;



  AdminVendorRoutePath.inputDetails(this.adminID, this.vendorID) : isUnknown = false, isDone = false;
  AdminVendorRoutePath.Login()
      : adminID = null,
        vendorID = null,
        isUnknown = false,
        isDone= false;
  AdminVendorRoutePath.AllVendor(this.adminID)
      :vendorID = null,
        isUnknown = false,
        isDone= false;
  AdminVendorRoutePath.unknown()
      : adminID = null,
        vendorID = null,
        isUnknown = true,
        isDone= false;

  AdminVendorRoutePath.Done()
      : adminID = null,
        vendorID = null,
        isUnknown = false,
        isDone= true;


  bool get isLoginPage => adminID == null && vendorID == null && isUnknown == false;

  bool get isInputDetailsPage => adminID != null && vendorID != null;

  bool get isAllVendorPage => adminID != null && vendorID == null;
}