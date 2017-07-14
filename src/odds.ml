type t = Random.State.t -> int * (int * int) list

let inject i _ = (i, [])
let roll ?state t =
	let state = match state with
		| None -> Random.State.make_self_init ()
		| Some state -> state
	in
	t state
	

let lift1 f x = fun state ->
	let (x, xrolls) = roll ~state x in
	(f x, xrolls)
let lift2 f x y = fun state ->
	let (x, xrolls) = roll ~state x in
	let (y, yrolls) = roll ~state y in
	(f x y, xrolls @ yrolls)

let die_unsafe d = fun state ->
	let result = 1 + Random.State.int state d in
	(result, [(d, result)])
let die d = fun state ->
	let (d,drolls) = roll ~state d in
	if d <= 0 then
		raise (Invalid_argument "Odds.die: cannot roll illsided die")
	else
		let (result, rrolls) = die_unsafe d state in
		(result, drolls @ rrolls)

let rec dice_unsafe n d = fun state ->
	if n = 0 then
		inject 0 state
	else
		lift2 (+) (die_unsafe d) (dice_unsafe (pred n) d) state
let dice n d = fun state ->
	let (d,drolls) = roll ~state d in
	if d <= 0 then
		raise (Invalid_argument "Odds.dice: cannot roll illsided dice")
	else
		let (n, nrolls) = roll ~state n in
		if n < 0 then
			raise (Invalid_argument "Odds.dice: cannot roll a negative quantity of dice")
		else
			let (result, rrolls) = dice_unsafe n d state in
			(result, drolls @ nrolls @ rrolls)

module Integer = struct
	let ( ! ) = inject
	let ( % ) = dice
	let ( + ) = lift2 ( + )
	let ( - ) = lift2 ( - )
	let ( ~- ) = lift1 ( ~- )
	let ( * ) = lift2 ( * )
	let ( / ) = lift2 ( / )
	let ( mod ) = lift2 ( mod )
	let max = lift2 max
	let min = lift2 min
end

