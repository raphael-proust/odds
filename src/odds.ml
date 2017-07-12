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


let roll_1 d =
	if d <= 0 then
		raise (Invalid_argument "Odds: negative or null sidedness")
	else
		1 + Random.int d

let apply_bin l binop r = match binop with
	| Add -> l + r
	| Sub -> l - r
	| Mul -> l * r
	| Div -> l / r
	| Dice -> 
		let rec loop acc n =
			if n <= 0 then
				acc
			else
				loop (acc + roll_1 r) (n - 1)
		in
		loop 0 l

let apply_un unop t = match unop with
	| Neg -> ~- t

let rec roll = function
	| Binop (r, binop, l) -> apply_bin (roll r) binop (roll l)
	| Unop (unop, t) -> apply_un unop (roll t)
	| K n -> n


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
