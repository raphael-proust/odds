type _ Effect.t +=
	| Roll : int -> int Effect.t

let fold f init n faces =
	assert (n >= 0);
	assert (faces > 0);
	let rec loop acc n =
		if n = 0 then
			acc
		else
			let r = Effect.perform (Roll faces) in
			loop (f acc r) (n - 1)
	in
	loop init n

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

let rec eval = function
  | Constant i -> i
  | Dice (rolls, faces) -> fold (+) 0 rolls faces
  | Plus (f1, f2) ->
      let i1 = eval f1 in
      let i2 = eval f2 in
      i1 + i2
  | Minus (f1, f2) ->
      let i1 = eval f1 in
      let i2 = eval f2 in
      i1 - i2
  | Mult (f1, f2) ->
      let i1 = eval f1 in
      let i2 = eval f2 in
      i1 * i2
  | Div (f1, f2) ->
      let i1 = eval f1 in
      let i2 = eval f2 in
      i1 / i2
  | Neg f ->
      let i = eval f in
      ~- i
  | Best [] -> assert false
  | Best fs ->
      List.fold_left
        (fun acc f -> let r = eval f in max acc r)
        min_int
        fs
  | Worst [] -> assert false
  | Worst fs ->
      List.fold_left
        (fun acc f -> let r = eval f in min acc r)
        max_int
        fs
