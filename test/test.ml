
let test () =
	let open Odds in
	assert (roll (D (1,1)) = 1);
	()

let () = test ()
