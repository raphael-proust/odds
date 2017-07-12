type binop = Types.binop =
	| Add
	| Sub
	| Mul
	| Div
	| Dice
type unop = Types.unop =
	| Neg
type t = Types.t =
	| Binop of t * binop * t
	| Unop of unop * t
	| K of int


let roll_1 state recorder d =
	if d <= 0 then
		raise (Invalid_argument "Odds: negative or null sidedness")
	else
		let result = 1 + Random.State.int state d in
		recorder d result;
		result

let apply_bin state recorder l binop r = match binop with
	| Add -> l + r
	| Sub -> l - r
	| Mul -> l * r
	| Div -> l / r
	| Dice -> 
		let rec loop acc n =
			if n <= 0 then
				acc
			else
				loop (acc + roll_1 state recorder r) (n - 1)
		in
		loop 0 l

let apply_un unop t = match unop with
	| Neg -> ~- t

let rec roll state recorder = function
	| Binop (l, binop, r) ->
		let l = roll state recorder l in
		let r = roll state recorder r in
		apply_bin state recorder l binop r
	| Unop (unop, t) ->
		let t = roll state recorder t in
		apply_un unop t
	| K n -> n

let null_recorder (_sides:int) (_result:int) = ()

let roll ?state ?(recorder=null_recorder) t =
	let state = match state with
		| None -> Random.State.make_self_init ()
		| Some state -> state
	in
	roll state recorder t


let t_of_string s = Parser.entry Lexer.token (Lexing.from_string s)

let string_of_binop = function
	| Add -> "+"
	| Sub -> "-"
	| Mul -> "*"
	| Div -> "/"
	| Dice -> "d"
let string_of_unop = function
	| Neg -> "-"
let rec string_of_t = function
	(*TODO: use printf and buffers*)
	| K n -> (string_of_int n, false)
	| Binop (r, op, l) ->
		let (r, rp) = string_of_t r in
		let r = if rp then "(" ^ r ^ ")" else r in
		let (l, lp) = string_of_t l in
		let l = if lp then "(" ^ l ^ ")" else l in
		(r ^ string_of_binop op ^ l, true)
	| Unop (op, t) ->
		let (t, tp) = string_of_t t in
		let t = if tp then "(" ^ t ^ ")" else t in
		(string_of_unop op ^ t, true)
		

let string_of_t t =
	fst (string_of_t t)
