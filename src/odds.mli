type binop = Types.binop =
	| Add
	| Sub
	| Mul
	| Div
	| Dice
type unop = Types.unop =
	| Neg
type t = Types.t =
	| Binop of t * binop * t
	| Unop of unop * t
	| K of int

val roll: ?state:Random.State.t -> ?recorder:(int -> int -> unit) -> t -> int

val t_of_string: string -> t
val string_of_t: t -> string
