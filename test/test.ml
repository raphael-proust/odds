
let test () =
	let open Odds in
	let open Odds.Integer in
	let open Odds_parser in
	assert ( roll !1 = (1,[]) );
	assert ( roll (!1 % !1) = (1, [(1,1)]) );
	assert ( roll (!1 + !1 % !1) = (2, [(1,1)]) );
	assert ( roll (t_of_string "1d1") = (1, [(1,1)]) );
	assert (
		try
			let (_:int * (int * int) list) = roll (!1 % ( ~- !1)) in
			false
		with Invalid_argument _ ->
			true
	);
	assert ( roll (t_of_string "1d1+1d1+1d1+1d1+1d1") = (5, [(1,1);(1,1);(1,1);(1,1);(1,1);]) );
	assert (
		let state1 = Random.State.make [| 1111111; 1111112; 1111114; 1111118; 9999990 |] in
		let state2 = Random.State.copy state1 in
		let t = !1000 % !1000 in
		roll ~state:state1 t = roll ~state:state2 t
	);
	()

let () = test ()
