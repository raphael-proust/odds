(**
Odds (Ocaml Dice Dice Something) is a library for rolling dice. It embeds the
dice algebra into OCaml by providing dice rolling functions and lifting
integer operations.
*)

type 'a t

val roll_fold: ?state: Random.State.t -> folder: ('acc -> int -> int -> 'acc) -> init: 'acc -> 'a t -> ('a * 'acc)
val roll: ?state:  Random.State.t -> 'a t -> 'a

val inject : 'a -> 'a t
val die: int -> int t
val dice: int -> int -> int t
val lift1: ('a -> 'b) -> 'a t -> 'b t
val lift2: ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t

module Monad: sig
	val return: 'a -> 'a t
	val die: int -> int t
	val dice: int -> int -> int t
	val bind: 'a t -> ('a -> 'b t) -> 'b t
	val ( >>= ): 'a t -> ('a -> 'b t) -> 'b t
	val map: 'a t -> ('a -> 'b) -> 'b t
	val map2: 'a t -> 'b t -> ('a -> 'b -> 'c) -> 'c t
end

module Algebra: sig
	val ( ! ): int -> int t
	val die: int t -> int t
	val dice: int t -> int t -> int t
	val ( % ): int t -> int t -> int t
	val ( + ): int t -> int t -> int t
	val ( - ): int t -> int t -> int t
	val ( ~- ): int t -> int t
	val ( ~+ ): int t -> int t
	val succ: int t -> int t
	val pred: int t -> int t
	val abs: int t -> int t
	val ( * ): int t -> int t -> int t
	val ( / ): int t -> int t -> int t
	val ( mod ): int t -> int t -> int t
	val max: int t -> int t -> int t
	val min: int t -> int t -> int t
	val ( = ): int t -> int t -> bool t
	val ( <> ): int t -> int t -> bool t
	val ( < ): int t -> int t -> bool t
	val ( > ): int t -> int t -> bool t
	val ( <= ): int t -> int t -> bool t
	val ( >= ): int t -> int t -> bool t
end
