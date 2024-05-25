import 'package:get/get.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'Email': 'Email',
      'password': 'Password',
      'remember_me': 'Remember me',
      'no_account': "Don't have an Account?",
      'sign_up': 'Sign up now!!',
      'log_in': 'Log In',
    },
    'ar_SY': {
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'remember_me': 'تذكرني',
      'no_account': 'ليس لديك حساب؟',
      'sign_up': 'سجل الآن!!',
      'log_in': 'تسجيل الدخول',
    },
  };
}
