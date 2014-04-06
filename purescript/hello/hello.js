(function (_ps) {
    "use strict";
    _ps.Prelude = (function () {
        var module = {};
        var LT = {
            ctor: "Prelude.LT", 
            values: [  ]
        };
        var GT = {
            ctor: "Prelude.GT", 
            values: [  ]
        };
        var EQ = {
            ctor: "Prelude.EQ", 
            values: [  ]
        };
        function id(dict) {
            return dict.id;
        };
        function $less$less$less(dict) {
            return dict.$less$less$less;
        };
        function show(dict) {
            return dict.show;
        };
        function showNumberImpl(n) {  return n.toString();};
        function $less$dollar$greater(dict) {
            return dict.$less$dollar$greater;
        };
        function pure(dict) {
            return dict.pure;
        };
        function $less$times$greater(dict) {
            return dict.$less$times$greater;
        };
        function empty(dict) {
            return dict.empty;
        };
        function $less$bar$greater(dict) {
            return dict.$less$bar$greater;
        };
        function $$return(dict) {
            return dict.$$return;
        };
        function $greater$greater$eq(dict) {
            return dict.$greater$greater$eq;
        };
        function $plus(dict) {
            return dict.$plus;
        };
        function $minus(dict) {
            return dict.$minus;
        };
        function $times(dict) {
            return dict.$times;
        };
        function $div(dict) {
            return dict.$div;
        };
        function $percent(dict) {
            return dict.$percent;
        };
        function negate(dict) {
            return dict.negate;
        };
        function numAdd(n1) {  return function(n2) {    return n1 + n2;  };};
        function numSub(n1) {  return function(n2) {    return n1 - n2;  };};
        function numMul(n1) {  return function(n2) {    return n1 * n2;  };};
        function numDiv(n1) {  return function(n2) {    return n1 / n2;  };};
        function numMod(n1) {  return function(n2) {    return n1 % n2;  };};
        function numNegate(n) {  return -n;};
        function $eq$eq(dict) {
            return dict.$eq$eq;
        };
        function $div$eq(dict) {
            return dict.$div$eq;
        };
        function refEq(r1) {  return function(r2) {    return r1 === r2;  };};
        function refIneq(r1) {  return function(r2) {    return r1 !== r2;  };};
        function compare(dict) {
            return dict.compare;
        };
        function numCompare(n1) {  return function(n2) {    return n1 < n2 ? module.LT : n1 > n2 ? module.GT : module.EQ;  };};
        function $amp(dict) {
            return dict.$amp;
        };
        function $bar(dict) {
            return dict.$bar;
        };
        function $up(dict) {
            return dict.$up;
        };
        function shl(dict) {
            return dict.shl;
        };
        function shr(dict) {
            return dict.shr;
        };
        function zshr(dict) {
            return dict.zshr;
        };
        function complement(dict) {
            return dict.complement;
        };
        function numShl(n1) {  return function(n2) {    return n1 << n2;  };};
        function numShr(n1) {  return function(n2) {    return n1 >> n2;  };};
        function numZshr(n1) {  return function(n2) {    return n1 >>> n2;  };};
        function numAnd(n1) {  return function(n2) {    return n1 & n2;  };};
        function numOr(n1) {  return function(n2) {    return n1 | n2;  };};
        function numXor(n1) {  return function(n2) {    return n1 ^ n2;  };};
        function numComplement(n) {  return ~n;};
        function $bang$bang(xs) {  return function(n) {    return xs[n];  };};
        function $amp$amp(dict) {
            return dict.$amp$amp;
        };
        function $bar$bar(dict) {
            return dict.$bar$bar;
        };
        function not(dict) {
            return dict.not;
        };
        function boolAnd(b1) {  return function(b2) {    return b1 && b2;  };};
        function boolOr(b1) {  return function(b2) {    return b1 || b2;  };};
        function boolNot(b) {  return !b;};
        function $plus$plus(s1) {  return function(s2) {    return s1 + s2;  };};
        var showString_show = function (s) {
            return s;
        };
        var showString = function (_1) {
            return {
                show: showString_show
            };
        };
        var showOrdering_show = function (_1) {
            if (_1.ctor === "Prelude.LT") {
                return "LT";
            };
            if (_1.ctor === "Prelude.GT") {
                return "GT";
            };
            if (_1.ctor === "Prelude.EQ") {
                return "EQ";
            };
            throw "Failed pattern match";
        };
        var showOrdering = function (_1) {
            return {
                show: showOrdering_show
            };
        };
        var showNumber_show = showNumberImpl;
        var showNumber = function (_1) {
            return {
                show: showNumber_show
            };
        };
        var showBoolean_show = function (_1) {
            if (_1) {
                return "true";
            };
            if (!_1) {
                return "false";
            };
            throw "Failed pattern match";
        };
        var showBoolean = function (_1) {
            return {
                show: showBoolean_show
            };
        };
        var ordNumber_compare = numCompare;
        var ordNumber = function (_1) {
            return {
                compare: ordNumber_compare
            };
        };
        var on = function (f) {
            return function (g) {
                return function (x) {
                    return function (y) {
                        return f(g(x))(g(y));
                    };
                };
            };
        };
        var numNumber_negate = numNegate;
        var numNumber_$times = numMul;
        var numNumber_$plus = numAdd;
        var numNumber_$percent = numMod;
        var numNumber_$minus = numSub;
        var numNumber_$div = numDiv;
        var numNumber = function (_1) {
            return {
                $plus: numNumber_$plus, 
                $minus: numNumber_$minus, 
                $times: numNumber_$times, 
                $div: numNumber_$div, 
                $percent: numNumber_$percent, 
                negate: numNumber_negate
            };
        };
        var liftM1 = function (__dict_Monad_0) {
            return function (f) {
                return function (a) {
                    return $greater$greater$eq(__dict_Monad_0)(a)(function (_1) {
                        return $$return(__dict_Monad_0)(f(_1));
                    });
                };
            };
        };
        var liftA1 = function (__dict_Applicative_1) {
            return function (f) {
                return function (a) {
                    return $less$times$greater(__dict_Applicative_1)(pure(__dict_Applicative_1)(f))(a);
                };
            };
        };
        var flip = function (f) {
            return function (b) {
                return function (a) {
                    return f(a)(b);
                };
            };
        };
        var eqString_$eq$eq = refEq;
        var eqString_$div$eq = refIneq;
        var eqString = function (_1) {
            return {
                $eq$eq: eqString_$eq$eq, 
                $div$eq: eqString_$div$eq
            };
        };
        var eqNumber_$eq$eq = refEq;
        var eqNumber_$div$eq = refIneq;
        var eqNumber = function (_1) {
            return {
                $eq$eq: eqNumber_$eq$eq, 
                $div$eq: eqNumber_$div$eq
            };
        };
        var eqBoolean_$eq$eq = refEq;
        var eqBoolean_$div$eq = refIneq;
        var eqBoolean = function (_1) {
            return {
                $eq$eq: eqBoolean_$eq$eq, 
                $div$eq: eqBoolean_$div$eq
            };
        };
        var $$const = function (_1) {
            return function (_2) {
                return _1;
            };
        };
        var categoryArr_id = function (x) {
            return x;
        };
        var categoryArr_$less$less$less = function (f) {
            return function (g) {
                return function (x) {
                    return f(g(x));
                };
            };
        };
        var categoryArr = function (_1) {
            return {
                id: categoryArr_id, 
                $less$less$less: categoryArr_$less$less$less
            };
        };
        var boolLikeBoolean_not = boolNot;
        var boolLikeBoolean_$bar$bar = boolOr;
        var boolLikeBoolean_$amp$amp = boolAnd;
        var boolLikeBoolean = function (_1) {
            return {
                $amp$amp: boolLikeBoolean_$amp$amp, 
                $bar$bar: boolLikeBoolean_$bar$bar, 
                not: boolLikeBoolean_not
            };
        };
        var eqArray_$eq$eq = function (__dict_Eq_2) {
            return function (_1) {
                return function (_2) {
                    if (_1.length === 0) {
                        if (_2.length === 0) {
                            return true;
                        };
                    };
                    if (_1.length > 0) {
                        var _8 = _1.slice(1);
                        if (_2.length > 0) {
                            var _6 = _2.slice(1);
                            return $amp$amp(boolLikeBoolean({}))($eq$eq(__dict_Eq_2)(_1[0])(_2[0]))($eq$eq(eqArray(__dict_Eq_2))(_8)(_6));
                        };
                    };
                    return false;
                };
            };
        };
        var eqArray = function (_1) {
            return {
                $eq$eq: eqArray_$eq$eq(_1), 
                $div$eq: eqArray_$div$eq(_1)
            };
        };
        var eqArray_$div$eq = function (__dict_Eq_3) {
            return function (xs) {
                return function (ys) {
                    return not(boolLikeBoolean({}))($eq$eq(eqArray(__dict_Eq_3))(xs)(ys));
                };
            };
        };
        var bitsNumber_zshr = numZshr;
        var bitsNumber_shr = numShr;
        var bitsNumber_shl = numShl;
        var bitsNumber_complement = numComplement;
        var bitsNumber_$up = numXor;
        var bitsNumber_$bar = numOr;
        var bitsNumber_$amp = numAnd;
        var bitsNumber = function (_1) {
            return {
                $amp: bitsNumber_$amp, 
                $bar: bitsNumber_$bar, 
                $up: bitsNumber_$up, 
                shl: bitsNumber_shl, 
                shr: bitsNumber_shr, 
                zshr: bitsNumber_zshr, 
                complement: bitsNumber_complement
            };
        };
        var ap = function (__dict_Monad_4) {
            return function (f) {
                return function (a) {
                    return $greater$greater$eq(__dict_Monad_4)(f)(function (_2) {
                        return $greater$greater$eq(__dict_Monad_4)(a)(function (_1) {
                            return $$return(__dict_Monad_4)(_2(_1));
                        });
                    });
                };
            };
        };
        var $greater$greater$greater = function (__dict_Category_5) {
            return function (f) {
                return function (g) {
                    return $less$less$less(__dict_Category_5)(g)(f);
                };
            };
        };
        var $greater$eq = function (__dict_Ord_6) {
            return function (a1) {
                return function (a2) {
                    return (function (_1) {
                        if (_1.ctor === "Prelude.LT") {
                            return false;
                        };
                        return true;
                    })(compare(__dict_Ord_6)(a1)(a2));
                };
            };
        };
        var $greater = function (__dict_Ord_7) {
            return function (a1) {
                return function (a2) {
                    return (function (_1) {
                        if (_1.ctor === "Prelude.GT") {
                            return true;
                        };
                        return false;
                    })(compare(__dict_Ord_7)(a1)(a2));
                };
            };
        };
        var $less$eq = function (__dict_Ord_8) {
            return function (a1) {
                return function (a2) {
                    return (function (_1) {
                        if (_1.ctor === "Prelude.GT") {
                            return false;
                        };
                        return true;
                    })(compare(__dict_Ord_8)(a1)(a2));
                };
            };
        };
        var $less = function (__dict_Ord_9) {
            return function (a1) {
                return function (a2) {
                    return (function (_1) {
                        if (_1.ctor === "Prelude.LT") {
                            return true;
                        };
                        return false;
                    })(compare(__dict_Ord_9)(a1)(a2));
                };
            };
        };
        var $dollar = function (f) {
            return function (x) {
                return f(x);
            };
        };
        var $hash = function (x) {
            return function (f) {
                return f(x);
            };
        };
        module.LT = LT;
        module.GT = GT;
        module.EQ = EQ;
        module["++"] = $plus$plus;
        module.boolNot = boolNot;
        module.boolOr = boolOr;
        module.boolAnd = boolAnd;
        module.not = not;
        module["||"] = $bar$bar;
        module["&&"] = $amp$amp;
        module["!!"] = $bang$bang;
        module.numComplement = numComplement;
        module.numXor = numXor;
        module.numOr = numOr;
        module.numAnd = numAnd;
        module.numZshr = numZshr;
        module.numShr = numShr;
        module.numShl = numShl;
        module.complement = complement;
        module.zshr = zshr;
        module.shr = shr;
        module.shl = shl;
        module["^"] = $up;
        module["|"] = $bar;
        module["&"] = $amp;
        module.numCompare = numCompare;
        module[">="] = $greater$eq;
        module["<="] = $less$eq;
        module[">"] = $greater;
        module["<"] = $less;
        module.compare = compare;
        module.refIneq = refIneq;
        module.refEq = refEq;
        module["/="] = $div$eq;
        module["=="] = $eq$eq;
        module.numNegate = numNegate;
        module.numMod = numMod;
        module.numDiv = numDiv;
        module.numMul = numMul;
        module.numSub = numSub;
        module.numAdd = numAdd;
        module.negate = negate;
        module["%"] = $percent;
        module["/"] = $div;
        module["*"] = $times;
        module["-"] = $minus;
        module["+"] = $plus;
        module.ap = ap;
        module.liftM1 = liftM1;
        module[">>="] = $greater$greater$eq;
        module["return"] = $$return;
        module["<|>"] = $less$bar$greater;
        module.empty = empty;
        module.liftA1 = liftA1;
        module["<*>"] = $less$times$greater;
        module.pure = pure;
        module["<$>"] = $less$dollar$greater;
        module.showNumberImpl = showNumberImpl;
        module.show = show;
        module["#"] = $hash;
        module["$"] = $dollar;
        module[">>>"] = $greater$greater$greater;
        module["<<<"] = $less$less$less;
        module.id = id;
        module.on = on;
        module["const"] = $$const;
        module.flip = flip;
        module.categoryArr = categoryArr;
        module.showString = showString;
        module.showBoolean = showBoolean;
        module.showNumber = showNumber;
        module.numNumber = numNumber;
        module.eqString = eqString;
        module.eqNumber = eqNumber;
        module.eqBoolean = eqBoolean;
        module.eqArray = eqArray;
        module.showOrdering = showOrdering;
        module.ordNumber = ordNumber;
        module.bitsNumber = bitsNumber;
        module.boolLikeBoolean = boolLikeBoolean;
        return module;
    })();
    _ps.Data_Eq = (function () {
        var module = {};
        var Ref = function (value0) {
            return {
                ctor: "Data.Eq.Ref", 
                values: [ value0 ]
            };
        };
        var liftRef = function (_1) {
            return function (_2) {
                return function (_3) {
                    return _1(_2.values[0])(_3.values[0]);
                };
            };
        };
        var eqRef_$eq$eq = liftRef(_ps.Prelude.refEq);
        var eqRef_$div$eq = liftRef(_ps.Prelude.refIneq);
        var eqRef = function (_1) {
            return {
                $eq$eq: eqRef_$eq$eq, 
                $div$eq: eqRef_$div$eq
            };
        };
        module.Ref = Ref;
        module.liftRef = liftRef;
        module.eqRef = eqRef;
        return module;
    })();
    _ps.Control_Monad_Eff = (function () {
        var module = {};
        function retEff(a) {  return function() {    return a;  };};
        function bindEff(a) {  return function(f) {    return function() {      return f(a())();    };  };};
        function runPure(f) {  return f();};
        function untilE(f) {  return function() {    while (!f()) { }    return {};  };};
        function whileE(f) {  return function(a) {    return function() {      while (f()) {        a();      }      return {};    };  };};
        function forE(lo) {  return function(hi) {    return function(f) {      return function() {        for (var i = lo; i < hi; i++) {          f(i)();        }      };    };  };};
        function foreachE(as) {  return function(f) {    for (var i = 0; i < as.length; i++) {      f(as[i])();    }  };};
        var monadEff_$greater$greater$eq = bindEff;
        var monadEff_$$return = retEff;
        var monadEff = function (_1) {
            return {
                $$return: monadEff_$$return, 
                $greater$greater$eq: monadEff_$greater$greater$eq
            };
        };
        var applicativeEff_pure = _ps.Prelude["return"](monadEff({}));
        var applicativeEff_$less$times$greater = _ps.Prelude.ap(monadEff({}));
        var applicativeEff = function (_1) {
            return {
                pure: applicativeEff_pure, 
                $less$times$greater: applicativeEff_$less$times$greater
            };
        };
        var functorEff_$less$dollar$greater = _ps.Prelude.liftA1(applicativeEff({}));
        var functorEff = function (_1) {
            return {
                $less$dollar$greater: functorEff_$less$dollar$greater
            };
        };
        module.foreachE = foreachE;
        module.forE = forE;
        module.whileE = whileE;
        module.untilE = untilE;
        module.runPure = runPure;
        module.bindEff = bindEff;
        module.retEff = retEff;
        module.functorEff = functorEff;
        module.applicativeEff = applicativeEff;
        module.monadEff = monadEff;
        return module;
    })();
    _ps.Control_Monad_Eff_Unsafe = (function () {
        var module = {};
        function unsafeInterleaveEff(f) {  return f;};
        module.unsafeInterleaveEff = unsafeInterleaveEff;
        return module;
    })();
    _ps.Control_Monad_ST = (function () {
        var module = {};
        function newSTRef(val) {  return function () {    return { value: val };  };};
        function readSTRef(ref) {  return function() {    return ref.value;  };};
        function modifySTRef(ref) {  return function(f) {    return function() {      return ref.value = f(ref.value);    };  };};
        function writeSTRef(ref) {  return function(a) {    return function() {      return ref.value = a;    };  };};
        function newSTArray(len) {  return function(a) {    return function() {      var arr = [];      for (var i = 0; i < len; i++) {        arr[i] = a;      };      return arr;    };  };};
        function peekSTArray(arr) {  return function(i) {    return function() {      return arr[i];    };  };};
        function pokeSTArray(arr) {  return function(i) {    return function(a) {      return function() {        return arr[i] = a;      };    };  };};
        function runST(f) {  return f;};
        function runSTArray(f) {  return f;};
        module.runSTArray = runSTArray;
        module.runST = runST;
        module.pokeSTArray = pokeSTArray;
        module.peekSTArray = peekSTArray;
        module.newSTArray = newSTArray;
        module.writeSTRef = writeSTRef;
        module.modifySTRef = modifySTRef;
        module.readSTRef = readSTRef;
        module.newSTRef = newSTRef;
        return module;
    })();
    _ps.Debug_Trace = (function () {
        var module = {};
        function trace(s) {  return function() {    console.log(s);    return {};  };};
        var print = function (__dict_Show_10) {
            return function (o) {
                return trace(_ps.Prelude.show(__dict_Show_10)(o));
            };
        };
        module.print = print;
        module.trace = trace;
        return module;
    })();
    _ps.Main = (function () {
        var module = {};
        var main = _ps.Debug_Trace.trace("Hello, PureScript!");
        module.main = main;
        return module;
    })();
})((typeof module !== "undefined" && module.exports) ? module.exports : (typeof window !== "undefined") ? window.PS = window.PS || {} : (function () {
    throw "PureScript doesn't know how to export modules in the current environment";
})());
