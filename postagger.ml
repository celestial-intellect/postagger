open Printf
open Scanf
open Stats
open Arg

let corpusname = ref ""

let main () =
  printf "POSTRON2003\n";
  Arg.parse [("-corpus", String (fun x -> corpusname := x),
	      "corpus filename")] (fun x -> ())
    "Usage: compute-stats -corpus <corpusname>";
  Printf.printf "Reading corpus file %s\n" !corpusname;
  let (pt,ptt,pwt) = Stats.compute_stats !corpusname in
    printf "Enter string: %!";
    let s = read_line () in
    let words = (Pos.lexer s) in
      if (List.length words) > 1 then
	begin
	  printf "TAG sequence ";
	  let (p, path) = Pos.tag words(pt,ptt,pwt) in
	    Array.iter (Printf.printf "%d ") path;
	    printf "with probability %g\n" p;
	    exit 0
	end
      else
	begin
	  printf "number of words must be greater than 1\n";
	  exit 1
	end;;

main ();

