String convertRoleToDb(String role) {
  if (role.toLowerCase() == "admin") {
    return "wedding_admin";
  }
  return role;
}

String convertRoleFromDb(String roleDb) {
  if (roleDb.toLowerCase() == "wedding_admin") {
    return "Admin";
  }

  return roleDb;
}
