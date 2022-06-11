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

type unop = Neg
type binop = Add | Sub | Mul | Div | Max | Min
type formula =
	| Constant of int
	| Dice of int * int
	| Binop of binop * formula * formula
	| Unop of unop * formula

let apply_binop = function
	| Add -> ( + )
	| Sub -> ( - )
	| Mul -> ( * )
	| Div -> ( / )
	| Max -> max
	| Min -> min

let apply_unop Neg = ( ~- )

let rec eval = function
	| Constant i -> i
	| Dice (rolls, faces) -> fold (+) 0 rolls faces
	| Binop (binop, f1, f2) ->
		let i1 = eval f1 in
		let i2 = eval f2 in
		apply_binop binop i1 i2
	| Unop (unop, f) ->
		let i = eval f in
		apply_unop unop i
