MODULE WriteHex;

VAR
  i: INTEGER;

BEGIN
  i := -256;
  WHILE i <= 256 DO
    WriteHex(i);
    WriteLn;
    i := i + 1;
  END;
END WriteHex.
