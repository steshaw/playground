MODULE Fact;

CONST
  num = 12;

VAR
  result: INTEGER;
  i: INTEGER;

PROCEDURE RecursiveFactorial(n: INTEGER; VAR result: INTEGER);
  VAR rest : INTEGER;
BEGIN
  IF n <= 0 THEN
    result := 1
  ELSE
    RecursiveFactorial(n - 1, rest);
    result := n * rest
  END;
END RecursiveFactorial;

PROCEDURE IterativeFactorial(n: INTEGER; VAR result: INTEGER);
BEGIN
  IF n <= 0 THEN
    result := 1
  ELSE
    result := n;
    WHILE n > 1 DO
      n := n - 1;
      result := result * n;
    END;
  END
END IterativeFactorial;

BEGIN 
  i := 0;
  WHILE i <= num DO
    IterativeFactorial(i, result);
    Write(result);
    WriteLn;
    i := i + 1;
  END;

  i := 0;
  WHILE i <= num DO
    RecursiveFactorial(i, result);
    Write(result);
    WriteLn;
    i := i + 1;
  END;
END Fact.
