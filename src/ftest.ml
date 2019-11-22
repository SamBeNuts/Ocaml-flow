open Gfile
open Tools
open Ffa
open Graph
open Money

let create_gcaparev g = e_fold g (fun gr id1 id2 lbl -> new_arc gr id2 id1 (if lbl = max_int then max_int else 0)) g 


let rec print_list = function 
    [] -> ()
  | e::l -> print_int e ; print_string " " ; print_list l

let rec clean g gcaparev = 
  let find_lbl idd idf = match find_arc gcaparev idd idf with 
    | Some x -> x
    | None -> raise (Graph_error "clean") in
  e_fold g (fun gr id1 id2 lbl -> new_arc gr id1 id2 (find_lbl id1 id2)) (clone_nodes g)

let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf "\nUsage: %s infile source sink outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)

  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)

  (* These command-line arguments are not used for the moment. *)
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in

  (* Open file *)

  (*let graph = from_file infile in
    let graph_int = gmap graph int_of_string in
    let ford = ffa graph_int _source _sink in
    let clean_graph = clean graph ford in*)

  (* Rewrite the graph that has been read.*)
  (*let () = export outfile (gmap clean_graph string_of_int) in*)

  let (graph,l_name) = from_money_file infile in
  let ford = ffa graph _source _sink in
  let clean_graph = clean graph ford in

  let () = export_money outfile (gmap clean_graph string_of_int) l_name in

  ()

