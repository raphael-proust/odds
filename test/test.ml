
let test () =
	let open Odds in
	assert (roll [ D (1,1) ] = 1);
	assert (roll [ K 1 ] = 1);
	assert (roll [ K 1 ; D (1,1) ] = 2);
	()

let () = test ()
