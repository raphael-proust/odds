
let test () =
	let open Odds in
	assert (roll (Binop(K 1, Dice, K 1)) = 1);
	assert (roll (K 1) = 1);
	assert (roll (Binop(K 1, Add, Binop(K 1, Dice, K 1))) = 2);
	assert (t_of_string "1 d 6" = Binop(K 1, Dice, K 6));
	assert (t_of_string "1d  1+1" = Binop(Binop(K 1, Dice, K 1), Add, K 1));
	assert (
		try
			let (_:int) = roll (Binop (K 1, Dice, K (-1))) in
			false
		with Invalid_argument _ ->
			true
	);
	assert (roll (t_of_string "1d1+1d1+1d1+1d1+1d1") = 5);
	assert (
		let state1 = Random.State.make [| 1111111; 1111112; 1111114; 1111118; 9999990 |] in
		let state2 = Random.State.copy state1 in
		let t = Binop(K 1000, Dice, K 1000) in
		roll ~state:state1 t = roll ~state:state2 t
	);
	()

let () = test ()
