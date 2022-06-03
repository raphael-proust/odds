type _ Effect.t +=
	| Roll : int -> int Effect.t

let roll_multiple n faces =
	assert (n >= 0);
	assert (faces >= 0);
	let rec loop acc n =
		if n = 0 then
			acc
		else
			loop (acc + Effect.perform (Roll faces)) (n - 1)
	in
	loop 0 n

