(* A [roller] is a PRNG that's not even pretending to be random and that expects
   a specific set of rolls. *)
type roller = (int * int) list

let check (roller : roller) formula expected_result =
	let roller = ref roller in
	Effect.Deep.match_with
		Odds.Dice.eval formula
		{ Effect.Deep.
			retc = (fun r ->
				if !roller <> [] then
					Error (Failure "roller hasn't used all its rolls")
				else if r <> expected_result then
					let msg = Format.asprintf "expected result %d but got %d" expected_result r in
					Error (Failure msg)
				else Ok ()
			);
			exnc = (fun e -> Error e);
			effc = (fun (type a) (type b) (e : a Effect.t) : ((a, b) Effect.Deep.continuation -> b) option ->
				match e with
				| Odds.Dice.Roll faces -> Some (fun k ->
					match !roller with
					| [] -> Effect.Deep.discontinue k (Failure "roller ran out of rolls")
					| (expected_faces, r) :: roller_remainder ->
							if expected_faces = faces then begin
								roller := roller_remainder;
								Effect.Deep.continue k r
							end else
								let msg = Format.asprintf "roller expected %d faces but got %d" expected_faces faces in
								Effect.Deep.discontinue k (Failure msg)
				)
				| _ -> None
			) ;
		}

let () =
	Printf.printf "Checking roller%!";
	assert (Result.is_ok @@ check [(10,10)] Odds.Dice.(Dice (1, 10)) 10);
	Printf.printf ".%!";
	assert (Result.is_ok @@ check [(10,4)] Odds.Dice.(Dice (1, 10)) 4);
	Printf.printf ".%!";
	assert (Result.is_ok @@ check [(10, 5); (20, 3)] Odds.Dice.(Minus (Dice (1,10), Dice (1,20))) 2);
	Printf.printf ".%!";
	assert (Result.is_ok @@ check [] (Odds.Dice.Constant 0) 0);
	Printf.printf ".%!";
	Printf.printf "\nDone%!";
	exit 0;
