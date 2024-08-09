String MYTOKEN = "";

void setMYTOKEN(String value) {
  MYTOKEN = value; // MYTOKEN 변수에 전달된 값(value)을 할당
  print('MYTOKEN: $MYTOKEN');
}

String getMYTOKEN() => MYTOKEN; // MYTOKEN 변수 반환