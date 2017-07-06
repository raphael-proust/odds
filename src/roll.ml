
let formula = Cmdliner.Arg.(
	value & pos 0 string "0" & info [] ~doc:"The dice formula to roll" ~docv:"FORMULA"
)

let main formula =

	Random.self_init ();

	let t = Odds.t_of_string formula in
	let r = Odds.roll t in
	print_int r;
	print_newline ();
	flush_all ()


let main_t = Cmdliner.Term.(
	pure main $ formula
)

let info =
	Cmdliner.Term.info "roll"
		~doc:"Roll a dice formula"

let () = match Cmdliner.Term.eval (main_t, info) with
	| `Error _ -> exit 1
	| _ -> exit 0

