open Gfile
open Tools
open Ffa
open Graph

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
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in

  (* Open file *)
  let graph = from_file infile in

  (* Processing *)
  let graph_int = gmap graph int_of_string in
  let ford = ffa graph_int _source _sink in
  let clean_graph = clean ford ford in

  (* Rewrite the graph that has been read.*)
  let () = export outfile (gmap clean_graph string_of_int) in

  ()

