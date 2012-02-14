MODULE OSS; (* NW 19.9.93 / 17.11.94*)
  IMPORT Files;  (* Oberon, Texts *)

  CONST IdLen* = 32; KW = 34;
    (*symbols*) null = 0;
    times* = 1; div* = 3; mod* = 4; and* = 5; plus* = 6; minus* = 7; or* = 8;
    eql* = 9; neq* = 10; lss* = 11; geq* = 12; leq* = 13; gtr* = 14;
    period* = 18; comma* = 19; colon* = 20; rparen* = 22; rbrak* = 23;
    of* = 25; then* = 26; do* = 27;
    lparen* = 29; lbrak* = 30; not* = 32; becomes* = 33; number* = 34; ident* = 37;
    semicolon* = 38; end* = 40; else* = 41; elsif* = 42;
    if* = 44; while* = 46;
    array* = 54; record* = 55;
    const* = 57; type* = 58; var* = 59; procedure* = 60; begin* = 61; module* = 63; eof = 64;

  TYPE Ident* = ARRAY IdLen OF CHAR;

  VAR val*: INTEGER;
    id*: Ident;
    error*: BOOLEAN;

    ch: CHAR;
    nkw: INTEGER;
    errpos: INTEGER;
    R: Files.File;
    W: Files.File;
    keyTab  : ARRAY KW OF
        RECORD sym: INTEGER; id: ARRAY 12 OF CHAR END;

  PROCEDURE Mark*(msg: ARRAY OF CHAR);
    VAR p: INTEGER;
  BEGIN p := Files.Tell(R) - 1;
    IF p > errpos THEN
      Files.WriteString(W, "  pos "); Files.WriteLongInt(W, p, 1);
      Files.WriteString(W, " "); Files.WriteString(W, msg);
      Files.WriteLn(W); (* Files.Append(Oberon.Log, W.buf) *)
    END;
    errpos := p; error := TRUE
  END Mark;

  PROCEDURE Get*(VAR sym: INTEGER);

    PROCEDURE Ident;
      VAR i, k: INTEGER;
    BEGIN i := 0;
      REPEAT
        IF i < IdLen THEN id[i] := ch; INC(i) END;
        Files.Read(R, ch)
      UNTIL (ch < "0") OR (ch > "9") & (CAP(ch) < "A") OR (CAP(ch) > "Z");
      id[i] := 0X; k := 0;
      WHILE (k < nkw) & (id # keyTab[k].id) DO INC(k) END;
      IF k < nkw THEN sym := keyTab[k].sym ELSE sym := ident END
    END Ident;

    PROCEDURE Number;
    BEGIN val := 0; sym := number;
      REPEAT
        IF val <= (MAX(INTEGER) - ORD(ch) + ORD("0")) DIV 10 THEN
          val := 10 * val + (ORD(ch) - ORD("0"))
        ELSE Mark("number too large"); val := 0
        END;
        Files.Read(R, ch)
      UNTIL (ch < "0") OR (ch > "9")
    END Number;

    PROCEDURE comment;
    BEGIN Files.Read(R, ch);
      LOOP
        LOOP
          WHILE ch = "(" DO Files.Read(R, ch);
            IF ch = "*" THEN comment END
          END;
          IF ch = "*" THEN Files.Read(R, ch); EXIT END;
          IF Files.Eof(R) THEN EXIT END;
          Files.Read(R, ch)
        END;
        IF ch = ")" THEN Files.Read(R, ch); EXIT END;
        IF Files.Eof(R) THEN Mark("comment not terminated"); EXIT END
      END
    END comment;

  BEGIN
    WHILE ~Files.Eof(R) & (ch <= " ") DO Files.Read(R, ch) END;
    IF Files.Eof(R) THEN sym := eof
    ELSE
      CASE ch OF
         "&": Files.Read(R, ch); sym := and
      |  "*": Files.Read(R, ch); sym := times
      |  "+": Files.Read(R, ch); sym := plus
      |  "-": Files.Read(R, ch); sym := minus
      |  "=": Files.Read(R, ch); sym := eql
      |  "#": Files.Read(R, ch); sym := neq
      |  "<": Files.Read(R, ch);
          IF ch = "=" THEN Files.Read(R, ch); sym := leq ELSE sym := lss END
      |  ">": Files.Read(R, ch);
          IF ch = "=" THEN Files.Read(R, ch); sym := geq ELSE sym := gtr END
      |  ";": Files.Read(R, ch); sym := semicolon
      |  ",": Files.Read(R, ch); sym := comma
      |  ":": Files.Read(R, ch);
          IF ch = "=" THEN Files.Read(R, ch); sym := becomes ELSE sym := colon END
      |  ".": Files.Read(R, ch); sym := period
      |  "(": Files.Read(R, ch);
          IF ch = "*" THEN comment; Get(sym) ELSE sym := lparen END
      |  ")": Files.Read(R, ch); sym := rparen
      |  "[": Files.Read(R, ch); sym := lbrak
      |  "]": Files.Read(R, ch); sym := rbrak
      |  "0".."9": Number;
      |  "A" .. "Z", "a".."z": Ident
      |  "~": Files.Read(R, ch); sym := not
      ELSE Files.Read(R, ch); sym := null
      END
    END
  END Get;

  PROCEDURE Init*(T: ARRAY OF CHAR; pos: INTEGER);
  BEGIN error := FALSE; errpos := pos; R := Files.Open(T, "r"); Files.Read(R, ch)
  END Init;

  PROCEDURE EnterKW(sym: INTEGER; name: ARRAY OF CHAR);
  BEGIN keyTab[nkw].sym := sym; COPY(name, keyTab[nkw].id); INC(nkw)
  END EnterKW;

BEGIN W := Files.stdout; error := TRUE; nkw := 0;
  EnterKW(null, "BY");
  EnterKW(do, "DO");
  EnterKW(if, "IF");
  EnterKW(null, "IN");
  EnterKW(null, "IS");
  EnterKW(of, "OF");
  EnterKW(or, "OR");
  EnterKW(null, "TO");
  EnterKW(end, "END");
  EnterKW(null, "FOR");
  EnterKW(mod, "MOD");
  EnterKW(null, "NIL");
  EnterKW(var, "VAR");
  EnterKW(null, "CASE");
  EnterKW(else, "ELSE");
  EnterKW(null, "EXIT");
  EnterKW(then, "THEN");
  EnterKW(type, "TYPE");
  EnterKW(null, "WITH");
  EnterKW(array, "ARRAY");
  EnterKW(begin, "BEGIN");
  EnterKW(const, "CONST");
  EnterKW(elsif, "ELSIF");
  EnterKW(null, "IMPORT");
  EnterKW(null, "UNTIL");
  EnterKW(while, "WHILE");
  EnterKW(record, "RECORD");
  EnterKW(null, "REPEAT");
  EnterKW(null, "RETURN");
  EnterKW(null, "POINTER");
  EnterKW(procedure, "PROCEDURE");
  EnterKW(div, "DIV");
  EnterKW(null, "LOOP");
  EnterKW(module, "MODULE");
END OSS.
