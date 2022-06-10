Odds — OCaml Dice Dice Something
-------------------------------------------------------------------------------
%%VERSION%%

Odds is an OCaml library for rolling dice. It features deterministic dice rolls
and it uses effects in order to leave all PRNG choices to the binary/main rather
than embedding it in the library code.

## Installation

Odds can be installed with `opam`:

    opam install odds


## Structure

- `Odds.Dice` contains basic definitions for dice rolling. The code exported by
	this module only ever perform the `Odds.Dice.Roll` effect and no other
	side-effect. In particular it does not handle PNRG state: instead, the caller
	of `eval` is responsible for installing an effect handler for `Roll`.

- `roll` is an implementation of a simple dice-roller using the `Odds` library.
	It is mostly intended to be used as an example for how to use `Odds. In
	particular, how to handle the `Roll` effect.

- `tests/` contains tests for the parser (`Odds.Parser`, `Odds.Lexer`) and the
	roller (`Odds.Dice.eval` function). This latter test only checks that the
	evaluation of a formula performs the expected `Roll` effects, it does not make
	any assertion on the actual result.


## Documentation

To generate the documentation, use `dune build @doc`

To consult online documentation, visit <https://raphael-proust.github.io/code/odds/index.html>
