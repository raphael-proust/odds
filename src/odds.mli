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

val roll: ?state:Random.State.t -> ?recorder:(int -> int -> unit) -> t -> int

val t_of_string: string -> t
val string_of_t: t -> string

module DSL: sig
	val (!): int -> t
	val (%): t -> t -> t
	val ( + ): t -> t -> t
	val ( - ): t -> t -> t
	val ( ~- ): t -> t
	val ( * ): t -> t -> t
	val ( / ): t -> t -> t
end
