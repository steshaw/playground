brackets = ["[]", "()"]
def parse(s) { def t = brackets.inject(s){ a, b -> a.replace(b,"") }; t == s ? t : parse(t) }
args.each { println parse(it) == "" }
