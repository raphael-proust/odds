(** The Odds library never handles Randomness. Instead, it is up to the user of
    the library to install a handler for this [Roll faces] effect, continuing
    with a random number from [1] to [faces] inclusive. *)
type _ Effect.t +=
	| Roll : int -> int Effect.t

(** [fold f init rolls faces] folds [f] over [rolls] rolls of a [faces]-faced
    die starting with [init].

    E.g., [fold max 0 2 20] takes the best of two d20 rolls. *)
val fold : ('a -> int -> 'a) -> 'a -> int -> int -> 'a

type formula =
  | Constant of int
  | Dice of int * int
  | Plus of formula * formula
  | Minus of formula * formula
  | Mult of formula * formula
  | Div of formula * formula
  | Neg of formula
  | Best of formula list
  | Worst of formula list

val eval : formula -> int
