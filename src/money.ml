open Gfile
open Graph
open Printf

let rec sum l = match l with
  | [] -> 0
  | hd::tl -> hd + (sum tl)

let from_money_file path =
  let infile = open_in path in

  let rec loop_file l_name l_amount =
    try
      let line = input_line infile in
      let line = String.trim line in

      if line = "" then loop_file l_name l_amount

      else try Scanf.sscanf line "%s %d" (fun name amount -> (loop_file (name::l_name) (amount::l_amount)))
        with e ->
          Printf.printf "Cannot read line - %s:\n%s\n%!" (Printexc.to_string e) line ;
          failwith "from_money_file"

    with End_of_file -> (l_name, l_amount) (* Done *)in 

  let (l_name,l_amount) = loop_file [] [] in  
  close_in infile ;

  let nb_person = List.length l_amount in
  let total_amount = sum l_amount in
  let average_amount = total_amount / nb_person in


  let rec loop_graph graph n l = match l with
    | [] -> graph
    | amount::rest -> let graph2 = new_node graph n in
      let diff_amount = (amount-average_amount) in
      let graph3 = if diff_amount > 0
      (*vers le sink*)
        then new_arc graph2 n (nb_person + 1) diff_amount 
        else (if diff_amount < 0
        (*vers la source*)
              then new_arc graph2 0 n (-diff_amount) 
              else graph2) in
      loop_graph graph3 (n+1) rest in 

  let start_graph = new_node empty_graph 0 in
  let start_graph = new_node start_graph (nb_person + 1) in 
  let graph = loop_graph start_graph 1 l_amount in 


  let rec loop2_inter_graph x y graph = match y with
    | 0 -> graph
    | _ -> loop2_inter_graph x (y-1) (new_arc graph x y 1000) in

  let rec loop_inter_graph n graph = match n with
    | 1 -> graph
    | _ -> let graph2 = (loop2_inter_graph n (n-1) graph) in
      loop_inter_graph (n-1) graph2 in

  (loop_inter_graph nb_person graph,l_name)

let export_money path graph l_name =
  (* Open a write-file. *)
  let ff = open_out path in
  let nb_person = List.length l_name in
  let string_of_id id = if id = 0 || id = (nb_person+1) then (string_of_int id) else (List.nth l_name (id-1)) in

  (* Write in this file. *)
  fprintf ff "digraph finite_state_machine {\n\trankdir=LR;\n\tsize=\"8,5\"\n\tnode [shape = circle];\n";

  (* Write all arcs *)
  e_iter graph (fun id1 id2 lbl -> fprintf ff "\t%s -> %s [ label = \"%s\" ];\n" (string_of_id id1) (string_of_id id2) (if (int_of_string lbl) > 10000 then "inf" else lbl)) ;
  fprintf ff "}\n";

  close_out ff ;
  ()

