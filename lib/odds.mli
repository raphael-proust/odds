(**
Odds (Ocaml Dice Dice Something) is a library for rolling dice. It embeds the
dice algebra into OCaml by providing dice rolling functions and lifting
integer operations.
*)

(** The type of dice expressions. *)
type 'a t

(** [die s] is an expression for rolling one die of [s] sides: `1d[s]`.

    Raises [Invalid_argument] if [s] is negative.
 *)
val die: int -> int t

(** [dice n s] is an expression for rolling [n] dice of [s] sides: `[n]d[s]`.

    Raises [Invalid_argument] if [s] is negative or if [n] is negative.
 *)
val dice: int -> int -> int t

(** [inject x] is the trivial expression that always rolls to [x]. *)
val inject : 'a -> 'a t

(** [roll ?state t] is the result of the expression [t]. If the [state] is
    given, it is used as a seed to roll all the dice in order. Otherwise, a
    state is created for the formula.

    May raise [Invalid_argument] if any subexpression does.
*)
val roll: ?state:  Random.State.t -> 'a t -> 'a

(** [roll_fold ?state ~folder ~init t] is similar to [roll ?state t] except
    that: the function [folder] is called on each dice roll. Specifically,
    [folder acc s r] is called where [acc] is the latest accumulator, [s] is
    the number of sides of the rolled dice, and [r] is the result.

    May raise [Invalid_argument] if any subexpression does.
*)
val roll_fold: ?state: Random.State.t -> folder: ('acc -> int -> int -> 'acc) -> init: 'acc -> 'a t -> ('a * 'acc)

val lift1: ('a -> 'b) -> 'a t -> 'b t
val lift2: ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t

(** The [Monad] module provides a monad to express dice formulas. *)
module Monad: sig
	val return: 'a -> 'a t
	val bind: 'a t -> ('a -> 'b t) -> 'b t
	val ( >>= ): 'a t -> ('a -> 'b t) -> 'b t
	val map: 'a t -> ('a -> 'b) -> 'b t
	val ( >|= ): 'a t -> ('a -> 'b) -> 'b t
end

(** The [Algebra] module lifts most of the integer-related functions of the
    [Pervasives] module to apply to dice expressions. *)
module Algebra: sig

	(** [!] is [inject]. *)
	val ( ! ): int -> int t
	val die: int t -> int t
	val dice: int t -> int t -> int t

	(** [%] is [dice]. *)
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
end

module Comparisons: sig
	val ( = ): int t -> int t -> bool t
	val ( <> ): int t -> int t -> bool t
	val ( < ): int t -> int t -> bool t
	val ( > ): int t -> int t -> bool t
	val ( <= ): int t -> int t -> bool t
	val ( >= ): int t -> int t -> bool t
end
