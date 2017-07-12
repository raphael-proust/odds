
{

}

let ws = [' ' '\t' '\n' '\r']
let digit = ['0'-'9']

rule token = parse
	| ws+ { token lexbuf }
	| eof { Parser.EOF }
	| digit+ as i { Parser.INTEGER (int_of_string i) }
	| ['d' 'D'] { Parser.D }
	| '+' { Parser.PLUS }
	| '-' { Parser.DASH }
	| '/' { Parser.SLASH }
	| ['*' 'x'] { Parser.STAR }
	| '(' { Parser.LPAREN }
	| ')' { Parser.RPAREN }

	| _ { failwith "lexer error" }

