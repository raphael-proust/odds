
let seed = Cmdliner.Arg.(
	value & opt (some int) None & info ["s"; "seed"] ~doc:"The seed for the PRNG" ~docv:"SEED"
)

let verbose = Cmdliner.Arg.(
	value & flag & info ["v"; "verbose"] ~doc:"Verbose: print intermediate rolls"
)

let formula = Cmdliner.Arg.(
	value & pos 0 string "0" & info [] ~doc:"The dice formula to roll" ~docv:"FORMULA"
)

let main seed verbose formula =

	let state = match seed with
		| None -> None
		| Some seed -> Some (Random.State.make [| seed |])
	in
	let record = ref [] in
	let recorder side result = record := (side, result) :: !record in
	let recorder = if verbose then Some recorder else None in

	let t = Odds.t_of_string formula in
	let r = Odds.roll ?state ?recorder t in

	(match !record with
	| [] -> ()
	| _::_ as record ->
		List.iter
			(fun (s,r) -> Printf.printf "d%d: %d\n" s r)
			record
	);

	Printf.printf "%d\n%!" r


let main_t = Cmdliner.Term.(
	pure main $ seed $ verbose $ formula
)

let info =
	Cmdliner.Term.info "roll"
		~doc:"Roll a dice formula"

let () = match Cmdliner.Term.eval (main_t, info) with
	| `Error _ -> exit 1
	| _ -> exit 0

