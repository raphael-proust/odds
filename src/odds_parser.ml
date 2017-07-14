let t_of_string s = Parser.entry Lexer.token (Lexing.from_string s)
let parse = Parser.entry Lexer.token
