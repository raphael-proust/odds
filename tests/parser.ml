let check_formula_of_string s expected =
	let formula = Odds.Parser.entry Odds.Lexer.token (Lexing.from_string s) in
	formula = expected

let () =
	Printf.printf "Checking parser%!";
	assert (check_formula_of_string "1d10" Odds.Dice.(Dice (1, 10)));
	Printf.printf ".%!";
	assert (check_formula_of_string "1d10+1" Odds.Dice.(Plus (Dice (1, 10), Constant 1)));
	Printf.printf ".%!";
	Printf.printf "\nDone%!";
	exit 0;
