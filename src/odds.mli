
(* The type of a dice of a given sidedness. *)
type d = int
val d4: d
val d6: d
val d8: d
val d10: d
val d12: d
val d20: d
val d100: d

type t =
	| D of int * d
	| Plus of t list
	| Const of int

val roll: t -> int
