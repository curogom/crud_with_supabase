import 'package:crud_with_supabase/common/crud_exception.dart';

class CRUDAuthException extends CRUDException {
  const CRUDAuthException(super.message);

  static const CRUDAuthException wrongIDorPassword = CRUDAuthException(
    '이메일 혹은 패스워드가 잘못 되었습니다.',
  );

  static const CRUDAuthException wrongID = CRUDAuthException(
    '이메일이 잘못 되었습니다.',
  );

  static const CRUDAuthException duplicatedID = CRUDAuthException(
    '이메일이 이미 존재합니다.',
  );

  static const CRUDAuthException shortPassword = CRUDAuthException(
    '비밀번호는 최소 6자 이상이어야합니다.',
  );
}
