let rolls_of_formula formula =
	let rolls = ref [] in
	Effect.Deep.match_with
		Odds.Dice.eval formula
		{ Effect.Deep.retc = (fun _ -> Ok !rolls);
			exnc = (fun e -> Error e);
			effc = (fun (type a) (type b) (e : a Effect.t) : ((a, b) Effect.Deep.continuation -> b) option ->
				match e with
				| Odds.Dice.Roll faces -> Some (fun k ->
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
	Printf.printf "Checking roller%!";
	check_rolls_of_formula Odds.Dice.(Dice (1, 10)) (function Ok [10] -> () | _ -> assert false);
	Printf.printf ".%!";
	check_rolls_of_formula Odds.Dice.(Plus (Dice (1,10), Dice (1,20))) (function Ok [10;20] -> () | _ -> assert false);
	Printf.printf ".%!";
	check_rolls_of_formula (Odds.Dice.Constant 0) (function Ok [] -> () | _ -> assert false);
	Printf.printf ".%!";
	check_rolls_of_formula Odds.Dice.(Dice (1,0)) (function Error _ -> () | _ -> assert false);
	Printf.printf ".%!";
	Printf.printf "\nDone%!";
	exit 0;
