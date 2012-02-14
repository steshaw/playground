MODULE RISC;  (*NW 8.8.94 / 9.2.95*)
  IMPORT SYSTEM, Files, In (*, Texts, Oberon*);

  CONST MemSize* = 4096;  (*in bytes*)

    ADD = 0; SUB = 1; MUL = 2; Div = 3; Mod = 4; CMP = 5;
    Or = 8; AND = 9; BIC = 10; XOR = 11; LSH = 12; ASH1 = 13; CHK = 14;
    ADDI = 16; SUBI = 17; MULI = 18; DIVI = 19; MODI = 20; CMPI = 21;
    ORI = 24; ANDI = 25; BICI = 26; XORI = 27; LSHI = 28; ASHI = 29; CHKI = 30;
    LDW = 32; LDB = 33; POP = 34; STW = 36; STB = 37; PSH = 38;
    BEQ = 40; BNE = 41; BLT = 42; BGE = 43; BLE = 44; BGT = 45; BSR = 46;
    JSR = 48; RET = 49; RD = 50; WRD= 51; WRH = 52; WRL = 53;

  VAR PC, IR: INTEGER;
    R*: ARRAY 32 OF INTEGER;
    M*: ARRAY MemSize DIV 4 OF INTEGER;
    W: Files.File;

  (* R[0] = 0, R[30] = SP, R[31] = link *)

  PROCEDURE WriteHex(f: Files.File; n: INTEGER);
    PROCEDURE aux(n: INTEGER);
    VAR hexDigit : INTEGER;
    BEGIN
      IF n > 0 THEN
        hexDigit := n MOD 16;
        aux(n DIV 16);
        CASE hexDigit OF
        | 0:  Files.WriteString(f, "0");
        | 1:  Files.WriteString(f, "1");
        | 2:  Files.WriteString(f, "2");
        | 3:  Files.WriteString(f, "3");
        | 4:  Files.WriteString(f, "4");
        | 5:  Files.WriteString(f, "5");
        | 6:  Files.WriteString(f, "6");
        | 7:  Files.WriteString(f, "7");
        | 8:  Files.WriteString(f, "8");
        | 9:  Files.WriteString(f, "9");
        | 10: Files.WriteString(f, "A");
        | 11: Files.WriteString(f, "B");
        | 12: Files.WriteString(f, "C");
        | 13: Files.WriteString(f, "D");
        | 14: Files.WriteString(f, "E");
        | 15: Files.WriteString(f, "F");
        END;
      END;
    END aux;
  BEGIN
    IF n = 0 THEN
      Files.WriteString(f, "0");
    ELSIF n < 0 THEN
      Files.WriteString(f, "-");
      aux(-n);
    ELSE
      aux(n);
    END;
  END WriteHex;

  PROCEDURE Execute*(pc0: INTEGER (*; VAR in: Texts.Scanner; out: Files.File *));
    VAR opc, a, b, c, nxt: INTEGER;
  BEGIN R[31] := 0; PC := pc0 DIV 4;
    LOOP R[0] := 0; nxt := PC + 1;
      IR := M[PC];
      opc := IR DIV 4000000H MOD 40H;
      a := IR DIV 200000H MOD 20H;
      b := IR DIV 10000H MOD 20H;
      c := IR MOD 10000H;
      IF opc < ADDI THEN c := R[c MOD 20H]
      ELSIF c >= 8000H THEN DEC(c, 10000H)  (*sign extension*)
      END;
      CASE opc OF
         ADD, ADDI: R[a] := R[b] + c
      |  SUB, SUBI, CMP, CMPI: R[a] := R[b] - c
      |  MUL, MULI: R[a] := R[b] * c
      |  Div, DIVI: R[a] := R[b] DIV c
      |  Mod, MODI: R[a] := R[b] MOD c
      |  Or,  ORI : R[a] := SYSTEM.VAL(INTEGER, SYSTEM.VAL(SET, R[b]) + SYSTEM.VAL(SET, c))
      |  AND, ANDI: R[a] := SYSTEM.VAL(INTEGER, SYSTEM.VAL(SET, R[b]) * SYSTEM.VAL(SET, c))
      |  BIC, BICI: R[a] := SYSTEM.VAL(INTEGER, SYSTEM.VAL(SET, R[b]) - SYSTEM.VAL(SET, c))
      |  XOR, XORI: R[a] := SYSTEM.VAL(INTEGER, SYSTEM.VAL(SET, R[b]) / SYSTEM.VAL(SET, c))
      |  LSH, LSHI: R[a] := LSL(R[b], c)
      |  ASH1, ASHI: R[a] := ASH(R[b], c)
      |  CHK, CHKI:
        IF (R[a] < 0) OR (R[a] >= c) THEN
          Files.WriteString(W, "Trap at "); Files.WriteInt(W, PC, 2);
          Files.WriteLn(W); (* Files.Append(out, W.buf); *) EXIT
        END

      |  LDW: R[a] := M[(R[b] + c) DIV 4]
      |  LDB: R[a] := LSL(M[(R[b] + c) DIV 4], (R[b] + c) MOD 4 * 8) MOD 100H
      |  POP: R[a] := M[(R[b]) DIV 4]; INC(R[b], c)
      |  STW: M[(R[b] + c) DIV 4] := R[a]
      |  STB: (*not implemented*)
      |  PSH: DEC(R[b], c); M[(R[b]) DIV 4] := R[a]

      |  BEQ: IF R[a] = R[b] THEN nxt := PC + c END
      |  BNE: IF R[a] # R[b] THEN nxt := PC + c END
      |  BLT: IF R[a] < R[b] THEN nxt := PC + c END
      |  BGE: IF R[a] >= R[b] THEN nxt := PC + c END
      |  BLE: IF R[a] <= R[b] THEN nxt := PC + c END
      |  BGT: IF R[a] > R[b] THEN nxt := PC + c END
      |  BSR: nxt := PC + c; R[31] := (PC+1)*4
      |  JSR: nxt := IR MOD 4000000H; R[31] := (PC+1)*4
      |  RET: nxt := R[c MOD 20H] DIV 4; IF nxt = 0 THEN EXIT END

      |  RD:  In.Int(R[a])
      |  WRD: Files.WriteString(W, " "); Files.WriteInt(W, R[c], 1)
      |  WRH: WriteHex(W, R[c])
      |  WRL: Files.WriteLn(W); (* Files.Append(out, W.buf) *)
      END;
      PC := nxt
    END
  END Execute;

  PROCEDURE Load*(VAR code: ARRAY OF INTEGER; len: INTEGER);
    VAR i: INTEGER;
  BEGIN i := 0;
    WHILE i < len DO M[i] := code[i]; INC(i) END
  END Load;

  PROCEDURE State*;
  BEGIN
    Files.WriteString(W, "PC="); Files.WriteInt(W, PC*4, 8); Files.WriteLn(W);
    Files.WriteString(W, "SP="); Files.WriteInt(W, R[30], 8); Files.WriteLn(W);
    Files.WriteString(W, "FP="); Files.WriteInt(W, R[29], 8); Files.WriteLn(W);
    Files.WriteString(W, "R1="); Files.WriteInt(W, R[1], 8); Files.WriteLn(W);
    Files.WriteString(W, "R2="); Files.WriteInt(W, R[2], 8); Files.WriteLn(W);
    Files.WriteString(W, "R3="); Files.WriteInt(W, R[3], 8); Files.WriteLn(W);
    Files.WriteString(W, "R4="); Files.WriteInt(W, R[4], 8); Files.WriteLn(W);
    (* Files.Append(Oberon.Log, W.buf) *)
  END State;

BEGIN W := Files.stdout; (* Texts.OpenWriter(W) *)
END RISC.
