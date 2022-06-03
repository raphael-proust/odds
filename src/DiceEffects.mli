type _ Effect.t +=
	| Roll : int -> int Effect.t

val roll_multiple : int -> int -> int
