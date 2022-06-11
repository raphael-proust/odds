
let seed = Cmdliner.Arg.(
	value & opt (some int) None & info ["s"; "seed"] ~doc:"The seed for the PRNG" ~docv:"SEED"
)

let verbose = Cmdliner.Arg.(
	value & flag & info ["v"; "verbose"] ~doc:"Verbose: print intermediate rolls"
)

let formula = Cmdliner.Arg.(
	let doc = "The formula to roll. All the positional arguments are joined together to form the formula." in
	value & (pos_all string []) & (info [] ~doc ~docv:"FORMULA")
)

let main seed verbose formula =
	let state = match seed with
		| None -> Random.State.make_self_init ()
		| Some seed -> Random.State.make [| seed |]
	in
	let formula = String.concat " " formula in
	let formula = Odds.Parser.entry Odds.Lexer.token (Lexing.from_string formula) in
	let effc
		: type a b. a Effect.t -> ((a, b) Effect.Deep.continuation -> b) option
		= function
				| Odds.Dice.Roll faces -> Some (fun k ->
					let v = Random.State.int state faces in
					if verbose then Printf.printf "d%d: %d\n" faces v;
					Effect.Deep.continue k v
				)
				| _ -> None
	in
	Effect.Deep.try_with
		Odds.Dice.eval formula
		{ Effect.Deep.effc }


let main_t = Cmdliner.Term.(
	const main $ seed $ verbose $ formula
)

let info = Cmdliner.Cmd.info "roll" ~doc:"Roll a dice formula"

let cmd = Cmdliner.Cmd.v info main_t

let () =
	match Cmdliner.Cmd.eval_value cmd with
	| Ok (`Ok r) -> Printf.printf "%d\n%!" r; exit 0
	| Ok _ -> exit 0
	| Error _ -> exit 1
