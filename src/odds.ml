type 'a t = Random.State.t -> (int -> int -> unit) -> 'a

let inject i _ _ = i
let roll state folder t = t state folder
	
let die_unsafe (d: int) : int t = fun state folder ->
	let result = 1 + Random.State.int state d in
	folder d result;
	result
let die (d: int) : int t =
	if d <= 0 then
		raise (Invalid_argument "Odds.die: cannot roll illsided die")
	else
		die_unsafe d
let rec dice_unsafe (n: int) (d: int) : int t = fun state folder ->
	if n = 0 then
		0
	else
		let x = die_unsafe d state folder in
		let y = dice_unsafe (pred n) d state folder in
		x + y
let dice (n: int) (d: int) : int t =
	if d <= 0 then
		raise (Invalid_argument "Odds.dice: cannot roll illsided dice")
	else if n < 0 then
		raise (Invalid_argument "Odds.dice: cannot roll a negative quantity of dice")
	else
		dice_unsafe n d

let bind (t: 'a t) (f: 'a -> 'b t) : 'b t = fun state folder ->
	let r = t state folder in
	f r state folder
let lift1 (f: 'a -> 'b) (x: 'a t) : 'b t = fun state folder ->
	let x = roll state folder x in
	f x
let lift2 f x y = fun state folder ->
	let x = roll state folder x in
	let y = roll state folder y in
	f x y


let roll_fold ?state ~folder ~init t =
	let state = match state with
		| None -> Random.State.make_self_init ()
		| Some state -> state
	in
	let folded = ref init in
	let folder x y = folded := folder !folded x y in
	let result = roll state folder t in
	(result, !folded)
let roll ?state t =
	let state = match state with
		| None -> Random.State.make_self_init ()
		| Some state -> state
	in
	roll state (fun _ _ -> ()) t

module Monad = struct
	let return = inject
	let die = die
	let dice = dice
	let bind = bind
	let ( >>= ) = bind
	let map t f = lift1 f t
	let map2 t u f = lift2 f t u
	let run = roll
end

module Algebra = struct
	let ( ! ) = inject
	let die d = bind d die
	let dice (n: int t) (d: int t) : int t = bind n (fun n -> bind d (fun d -> dice n d))
	let ( % ) = dice
	let ( + ) = lift2 ( + )
	let ( - ) = lift2 ( - )
	let ( ~- ) = lift1 ( ~- )
	let ( ~+ ) = lift1 ( ~+ )
	let succ = lift1 succ
	let pred = lift1 pred
	let abs = lift1 abs
	let ( * ) = lift2 ( * )
	let ( / ) = lift2 ( / )
	let ( mod ) = lift2 ( mod )
	let max = lift2 max
	let min = lift2 min
	let ( = ) = lift2 ( = )
	let ( <> ) = lift2 ( <> )
	let ( < ) = lift2 ( < )
	let ( > ) = lift2 ( > )
	let ( <= ) = lift2 ( <= )
	let ( >= ) = lift2 ( >= )
end

