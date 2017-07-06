
(* The type of a dice of a given sidedness. *)
type d = int
val d4: d
val d6: d
val d8: d
val d10: d
val d12: d
val d20: d
val d100: d

type u = Types.u =
	| D of int * d
	| K of int
type t = u list

val roll: t -> int

val t_of_string: string -> t
