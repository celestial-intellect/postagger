open Printf
open Scanf

let sum_matrix a =
  Array.fold_left (+) 0 (Array.map (Array.fold_left (+) 0) a)

let compute_stats corpus = 
  let buf = Scanning.from_file corpus in
  let tagcount = Array.make 10 1 in
  let bitagcount = Array.make_matrix 10 10 1 in
  let wordtag = Array.make_matrix 26 10 1 in
  let n = ref 0 in
  let tprev = ref 0 in
    while not (Scanning.end_of_input buf) do
      begin
	bscanf buf "%c/%d "
	  (fun w t ->
	     let wix = Char.code w - Char.code 'a' in
	       n := !n+ 1;
	       tagcount.(t) <- tagcount.(t) + 1;
	       if !n>1 then
		 bitagcount.(t).(!tprev) <-
		 bitagcount.(t).(!tprev) + 1; 
	       tprev := t;
	       wordtag.(wix).(t) <- wordtag.(wix).(t) + 1
	  );
      end
    done;
    let totaltagcount = Array.fold_left (+) 0 tagcount in
    let totalbitagcount = sum_matrix bitagcount in
    let totalwordtag = sum_matrix wordtag in
    let pt = Array.make 10 0.0 in
    let ptt = Array.make_matrix 10 10 0.0 in
    let pwt = Array.make_matrix 26 10 0.0 in
    let out = open_out "prob.txt" in
      for i = 0 to 9 do
	let p = float_of_int(tagcount.(i)) /.
		  float_of_int(totaltagcount) in
	  pt.(i) <- p;
	  fprintf out "P(t_%d)=%f\n" i p;
      done;
      for i = 0 to 9 do
	for j = 0 to 9 do
	  let p = float_of_int(bitagcount.(i).(j)) /.
		    float_of_int(totalbitagcount) in
	    ptt.(i).(j) <- p;
	    fprintf out "P(t_%d|t_%d)=%f\n" i j p;
	done
      done;
      for i = 0 to 25 do
	for j = 0 to 9 do
	  let p = float_of_int(wordtag.(i).(j)) /.
		    float_of_int(totalwordtag) in
	    pwt.(i).(j) <- p;
	    fprintf out "P(w_%d|t_%d)=%f\n" i j p;
	done
      done;
      (pt, ptt, pwt)

      
