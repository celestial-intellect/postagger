
open Stats
open Arg

let corpusname = ref ""

let main () =
  Arg.parse [("-corpus", String (fun x -> corpusname := x),
	      "corpus filename")] (fun x -> ()) 
    "Usage: compute-stats -corpus <corpusname>";
  Printf.printf "Reading corpus file %s\n" !corpusname;
  compute_stats !corpusname;;
  

main ();;

