def parse(s) { def t = s.replace("[]", "").replace("()", ""); t == s ? t : parse(t) }
args.each { println parse(it) == "" }
