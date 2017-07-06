
{

}

let ws = [' ' '\t' '\n' '\r']
let digit = ['0'-'9']

rule token = parse
	| ws+ { token lexbuf }
	| eof { Parser.EOF }
	| ['d' 'D'] { Parser.DICE }
	| '+' { Parser.PLUS }
	| digit+ as i { Parser.INTEGER (int_of_string i) }

	| _ { failwith "lexer error" }

