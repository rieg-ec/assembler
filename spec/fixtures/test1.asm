DATA:
  a 10
          b        12 // comment
var3 4
CODE:
  MOV A, (var3)
                MOV A, (a)
  MOV B, (b)
  ADD A, B
  MOV (100), A
  JMP label4 // second comment
label1:
  MOV A, 0
  JMP label2
label2:
  CALL label3
label3:
  PUSH A
  PUSH B
label4:
  POP A
  POP B
  JMP label1
