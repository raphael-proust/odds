type prerolls = (int * int) list

let handler
	(check: (int, int) Effect.Shallow.continuation -> int -> prerolls -> unit)
	preroll
	expected
=
	{ Effect.Shallow.
		retc = begin fun x ->
			(*final check: all prerolls used and result as expected*)
			if preroll <> [] then failwith "not as many rolls as preroll";
			if x <> expected then failwith "unexpected result";
			()
		end;
		exnc = raise;
		effc = fun (type b) (eff : b Effect.t) ->
			match eff with
			| Odds.Dice.Roll faces -> Some begin fun (k: (b, _) Effect.Shallow.continuation) ->
				(*use a preroll to resolve the Roll effect*)
				match preroll with
				| [] -> failwith "more rolls than preroll"
				| (prerolled, expected_faces) :: preroll ->
					(*check facedness is as expected*)
					if faces <> expected_faces then failwith "unexpected facedness";
					check k prerolled preroll
				end
				| _ -> None
	}

let check_formula_of_string s preroll expected =
	(*main loop of testing*)
	let rec check (eval : (int, int) Effect.Shallow.continuation) roll preroll =
		Effect.Shallow.continue_with eval roll (handler check preroll expected)
	in
	(*boilerplate to enter the main loop*)
	let eval s = Odds.Parser.entry Odds.Lexer.token (Lexing.from_string s) in
	let eval = Effect.Shallow.fiber eval in
	Effect.Shallow.continue_with eval s (handler check preroll expected)

let () = check_formula_of_string "1d10" [(1,10)] 1
let () = check_formula_of_string "2d10" [(1,10); (2,10)] 3
let () = check_formula_of_string "3d10k2 +1" [(1,10); (10,10); (9,10)] 20
let () = check_formula_of_string "3d10k2 + 1d2" [(10,10); (4,10); (10,10); (2,2)] 22
