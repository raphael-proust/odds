
let test () =
	let open Odds in
	assert (roll [ D (1,1) ] = 1);
	assert (roll [ K 1 ] = 1);
	assert (roll [ K 1 ; D (1,1) ] = 2);
	assert (t_of_string "1 d 6" = [ D (1, 6) ]);
	assert (t_of_string "1d  1+1" = [ D (1, 1) ; K 1 ]);
	assert (
		try
			let (_:int) = roll [ D (1,-1) ] in
			false
		with Invalid_argument _ ->
			true
	);
	()

let () = test ()
