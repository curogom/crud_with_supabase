import 'package:crud_with_supabase/common/crud_exception.dart';

class CRUDLoginException extends CRUDException {
  const CRUDLoginException(super.message);

  static const CRUDLoginException wrongIDorPassword = CRUDLoginException(
    '이메일 혹은 패스워드가 잘못 되었습니다.',
  );
}
