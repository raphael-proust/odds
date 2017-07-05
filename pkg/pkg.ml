#!/usr/bin/env ocaml
#use "topfind";;
#require "topkg"
open Topkg

let () =
  Pkg.describe "odds" @@ fun c ->
  Ok [ Pkg.mllib "src/odds.mllib";
       Pkg.test "test/test"; ]
