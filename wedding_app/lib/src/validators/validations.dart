
class Validation{
    static bool isStringValid(String text, int length){
        return text!=null && text.length >= length;
    }
    static bool isEmailValid(String email){
        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    }
}