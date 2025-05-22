(** The Odds library never handles Randomness. Instead, it is up to the user of
    the library to install a handler for this [Roll faces] effect, continuing
    with a random number from [1] to [faces] inclusive. *)
type _ Effect.t += Roll : int -> int Effect.t

val d : int -> int -> int

val dk: int -> int -> int -> int
