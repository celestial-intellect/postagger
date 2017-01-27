open Scanf
open Printf

let lexer str =
  let buf = Scanning.from_string str in
  let wlist = ref [] in
    while not (Scanning.end_of_input buf) do
      bscanf buf "%c "
	(fun x -> wlist := (Char.code x - Char.code 'a') :: !wlist)
    done;
    List.rev !wlist

(* a hopefully correct implementation of viterbi *)
let tag words (pt, ptt, pwt) =
  let words = Array.of_list words in
  let n = Array.length words in
  let d = Array.make_matrix n 10 0.0 in (*delta function*)
  let c = Array.make_matrix n 10 0 in	(* back pointer *)
    (* initialize first column of trellis *)
    for i = 0 to 9 do
      d.(0).(i) <- pt.(i) *. pwt.(words.(0)).(i);
    done;
    (* compute probabilities *)
    for i = 1 to (n-1) do		(* word index *)
      for j = 0 to 9 do			(* possible tags in a column *)
	let max = ref 0.0 in
	let ixmax = ref 0 in
	  for k = 0 to 9 do
	    let dj = d.(i-1).(k) *. ptt.(j).(k) 
	    in
	      if dj > !max then
		begin
		  max := dj;
		  ixmax := k;
		end
	  done;
	  d.(i).(j) <- !max *. pwt.(words.(i)).(j);
	  c.(i).(j) <- !ixmax;
      done;
    done;
    let path = Array.make n 0 in
    let p = ref 0.0 in
    let pix = ref 0 in
      for k = 0 to 9 do
	if d.(n-1).(k) > !p then
	  begin
	    p := d.(n-1).(k);
	    pix := k;
	  end
      done;
      path.(n-1) <- !pix;
      (* reconstruct path *)
      for i = n-1 downto 1 do
	path.(i-1) <- c.(i).(path.(i));
      done;
      (!p, path)
      
    
