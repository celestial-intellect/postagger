open Arg

let corpusname = ref ""

let main () =
  Arg.parse [("-corpus", String (fun x -> corpusname := x),
	      "corpus filename")] (fun x -> ()) 
    "Usage: compute-stats -corpus <corpusname>";
  Random.self_init ();
  for i = 0 to 10000 do
    Printf.printf "%c/%d\n" (Char.chr ((Random.int 26) + (Char.code 'a')))
      (Random.int 10)
  done;;

main ();;

