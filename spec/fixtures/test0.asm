DATA:
  a 1
  b 2
  var3 3
CODE:
  MOV A, (var3)
label1:
  JCR label1
