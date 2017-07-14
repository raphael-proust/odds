type t

val roll: ?state: Random.State.t -> t -> (int * (int * int) list)

val inject : int -> t
val die: t -> t
val dice: t -> t -> t

val lift1: (int -> int) -> t -> t
val lift2: (int -> int -> int) -> t -> t -> t

module Integer : sig
	val ( ! ): int -> t
	val ( % ): t -> t -> t
	val ( + ): t -> t -> t
	val ( - ): t -> t -> t
	val ( ~- ): t -> t
	val ( * ): t -> t -> t
	val ( / ): t -> t -> t
	val ( mod ): t -> t -> t
	val max: t -> t -> t
	val min: t -> t -> t
end
