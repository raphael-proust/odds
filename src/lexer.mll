{

}

let ws = [' ' '\t' '\n' '\r']
let digit = ['0'-'9']

rule token = parse
	| ws+ { token lexbuf }
	| eof { Parser.EOF }
	| digit+ as i { Parser.INTEGER (int_of_string i) }
	| ['d' 'D'] { Parser.D }
	| ['k' 'K'] { Parser.K }
	| '+' { Parser.PLUS }
	| '-' { Parser.DASH }
	| '/' { Parser.SLASH }
	| ['*' 'x'] { Parser.STAR }
	| '(' { Parser.LPAREN }
	| ')' { Parser.RPAREN }
	| "max" { Parser.MAX }
	| "min" { Parser.MIN }

	| _ { failwith "lexer error" }

