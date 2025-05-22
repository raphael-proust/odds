type _ Effect.t += Roll : int -> int Effect.t

let fold f init n faces =
	assert (n >= 0);
	assert (faces > 0);
	let rec loop acc n =
		if n = 0 then
			acc
		else
			let r = Effect.perform (Roll faces) in
			loop (f acc r) (n - 1)
	in
	loop init n

let rec keep n ys x =
	if n <= 0 then
		[]
	else match ys with
		| [] -> [x]
		| y :: ys ->
			if y >= x then
				y :: keep (n - 1) ys x
			else
				x :: keep (n - 1) ys y

let d rolls faces = fold (+) 0 rolls faces
let dk rolls faces keeps = List.fold_left (+) 0 @@ fold (keep keeps) [] rolls faces
