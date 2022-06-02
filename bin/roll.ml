
let seed = Cmdliner.Arg.(
	value & opt (some int) None & info ["s"; "seed"] ~doc:"The seed for the PRNG" ~docv:"SEED"
)

let verbose = Cmdliner.Arg.(
	value & flag & info ["v"; "verbose"] ~doc:"Verbose: print intermediate rolls"
)

let formula = Cmdliner.Arg.(

	let doc =
		"The formula to roll. All the positional arguments are \
                 joined together to form the formula."
	in
	value & (pos_all string []) & (info [] ~doc ~docv:"FORMULA")
)

let main seed verbose formula =

	let state = match seed with
		| None -> None
		| Some seed -> Some (Random.State.make [| seed |])
	in

	let formula = String.concat " " formula in

	let t = Odds_parser.t_of_string formula in
	
	let r =
		if verbose then
			let folder () x y = Printf.printf "d%d: %d\n" x y in
			let init = () in
			fst (Odds.roll_fold ?state ~folder ~init t)
		else
			Odds.roll ?state t
	in

	Printf.printf "%d\n%!" r


let main_t = Cmdliner.Term.(
	const main $ seed $ verbose $ formula
)

let info =
	Cmdliner.Cmd.info "roll"
		~doc:"Roll a dice formula"

let cmd = Cmdliner.Cmd.v info main_t

let () =
	let code = Cmdliner.Cmd.eval cmd in
	exit code
