let test_core () =
	let open Odds in
	assert (
		try
			let _:int = roll (die  ~-1) in
			false
		with Invalid_argument _ ->
			true
	);
	assert (
		let state1 = Random.State.make [| 1111111; 1111112; 1111114; 1111118; 9999990 |] in
		let state2 = Random.State.copy state1 in
		let t = dice 1000 1000 in
		roll ~state:state1 t = roll ~state:state2 t
	);
	()

let test_algebra () =
	let open Odds.Algebra in
	assert ( Odds.roll (!1 % !1) = 1 );
	assert ( Odds.roll (!1 + !1 % !1) = 2 );
	assert ( Odds.roll (!1 + !1 % !1 + !1 % !1) = 3 );
	assert ( Odds.roll (!1 + min (!1 % !1) (!1000 % !1000 + !1)) = 2 );
	()

let test_comparisons () =
	let open Odds.Algebra in
	let open Odds.Comparisons in
	assert (Odds.roll ((!1 % !1) = !1) );
	assert (Odds.roll ((!1 + !1 % !1) = !2) );
	assert (Odds.roll ((!1 + !1 % !1 + !1 % !1) = !3) );
	assert (Odds.roll ((!1 + min (!1 % !1) (!1000 % !1000 + !1)) = !2) );
	()

let test_monad () =
	let open Odds in
	let open Odds.Monad in
	assert (
		Odds.roll (
			return 1 >>= fun x ->
			dice 1 1 >>= fun y ->
			die 1 >>= fun z ->
			return (x + y + z)
		) = 3
	);
	()
	
let test_parser () =
	let open Odds_parser in
	assert ( Odds.roll (t_of_string "1d1") = 1 );
	assert ( Odds.roll (t_of_string "1d1+1d1+1d1+1d1+1d1") = 5 );
	()

let test () =
	test_core ();
	test_algebra ();
	test_comparisons ();
	test_monad ();
	test_parser ();
	()

let () = test ()
