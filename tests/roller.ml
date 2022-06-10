let rolls_of_formula formula =
	let rolls = ref [] in
	Effect.Deep.match_with
		Odds.Dice.eval formula
		{ Effect.Deep.retc = (fun r -> Ok (r, !rolls));
			exnc = (fun e -> Error e);
			effc = (fun (type a) (type b) (e : a Effect.t) : ((a, b) Effect.Deep.continuation -> b) option ->
				match e with
				| Odds.Dice.Roll faces -> Some (fun k ->
					(* For testing: log effect, return max result *)
					rolls := faces :: !rolls;
					Effect.Deep.continue k faces
				)
				| _ -> None
			) ;
		}

let check_rolls_of_formula f check =
	let rolls = rolls_of_formula f in
	check rolls

let () =
	Printf.printf "Checking roller%!";
	assert (check_rolls_of_formula Odds.Dice.(Dice (1, 10)) (fun v -> v = Ok (10, [10])));
	Printf.printf ".%!";
	assert (check_rolls_of_formula Odds.Dice.(Minus (Dice (1,10), Dice (1,20))) (fun v -> v = Ok ((-10), [20;10])));
	Printf.printf ".%!";
	assert (check_rolls_of_formula (Odds.Dice.Constant 0) (fun v -> v = Ok (0, [])));
	Printf.printf ".%!";
	assert (check_rolls_of_formula Odds.Dice.(Dice (1,0)) Result.is_error);
	Printf.printf ".%!";
	Printf.printf "\nDone%!";
	exit 0;
