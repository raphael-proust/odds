type binop =
	| Add
	| Sub
	| Mul
	| Div
	| Dice
type unop =
	| Neg
type t =
	| Binop of t * binop * t
	| Unop of unop * t
	| K of int
