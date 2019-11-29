open Gfile
open Tools
open Ffa
open Graph
open Money

let () =
  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 3 then
    begin
      Printf.printf "\nUsage: %s infile outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;

  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)
  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)
  in

  (* Open file *)
  let (graph,l_name) = from_money_file infile in

  (* FFA *)
  let ford = ffa graph 0 ((List.length l_name)+1) in

  (* Rewrite the graph that has been read.*)
  let () = export_money outfile ford l_name in

  ()
  