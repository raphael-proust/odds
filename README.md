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

- `Odds.Dice` contains basic definitions for the `Roll` effect and for basic
	dice algebra operators: `d` and `d`-`k`.

- The parser (`parser.mly`) parses the string and emits the `Roll` effects as
	needed.

- `roll` is an implementation of a simple dice-roller using the `Odds` library
	and parser.

- `tests/parser.ml` tests the parser. It uses a Shallow effect handler to
	maintain a state of what rolls it expects to see and what pre-rolled values
	are used.


## Documentation

To generate the documentation, use `dune build @doc`

To consult online documentation, visit <https://raphael-proust.github.io/code/odds/index.html>
