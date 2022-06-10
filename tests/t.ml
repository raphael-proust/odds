
let rolls_of_formula formula =
	let rolls = ref [] in
	Effect.Deep.match_with
		(fun s -> Odds.Parser.entry Odds.Lexer.token (Lexing.from_string s)) formula
		{ Effect.Deep.retc = (fun _ -> Ok !rolls);
			exnc = (fun e -> Error e);
			effc = (fun (type a) (type b) (e : a Effect.t) : ((a, b) Effect.Deep.continuation -> b) option ->
				match e with
				| Odds.DiceEffects.Roll faces -> Some (fun k ->
					rolls := faces :: !rolls;
					Effect.Deep.continue k faces
				)
				| _ -> None
			) ;
		}

let check_rolls_of_formula f check =
	let rolls = rolls_of_formula f in
	let rolls = Result.map List.rev rolls in
	check rolls

let () =
	Printf.printf "Checking%!";
	check_rolls_of_formula "1d10" (function Ok [10] -> () | _ -> assert false);
	Printf.printf ".%!";
	check_rolls_of_formula "1d10+1d20" (function Ok [10;20] -> () | _ -> assert false);
	Printf.printf ".%!";
	check_rolls_of_formula "1" (function Ok [] -> () | _ -> assert false);
	Printf.printf ".%!";
	check_rolls_of_formula "(1d3)d(1d3)" (function Ok [3;3;3;3;3] -> () | _ -> assert false);
	Printf.printf ".%!";
	check_rolls_of_formula "1d0" (function Error _ -> () | _ -> assert false);
	Printf.printf ".%!";
	Printf.printf "\nDone%!";
	exit 0;
