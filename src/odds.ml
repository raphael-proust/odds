
(* The type of a dice of a given sidedness. *)
type d = int
let d4 = 4
let d6 = 6
let d8 = 8
let d10 = 10
let d12 = 12
let d20 = 20
let d100 = 100

let roll_1 d = 1 + Random.int d

type t =
	| D of int * d
	| Plus of t list
	| Const of int


let rec roll acc = function
	| D (n, s) ->
		let rec loop acc n =
			if n <= 0 then
				acc
			else
				loop (acc + roll_1 s) (n - 1)
		in
		loop acc n
	| Plus ts ->
		List.fold_left roll acc ts
	| Const k -> acc + k

let roll t = roll 0 t
