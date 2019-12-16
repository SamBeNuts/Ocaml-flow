open Gfile
open Graph
open Printf
open Tools

let from_money_file path =
  (* on ouvre le fichier *)
  let infile = open_in path in

  (* on parcourt le fichier *)
  let rec loop_file l_name l_amount =
    try
      let line = input_line infile in
      let line = String.trim line in

      if line = "" then loop_file l_name l_amount

      (* Pour chaque ligne, on récupère le nom et le montant d'argent et on les stocke dans des listes *)
      else try Scanf.sscanf line "%s %d" (fun name amount -> (loop_file (name::l_name) (amount::l_amount)))
        with e ->
          Printf.printf "Cannot read line - %s:\n%s\n%!" (Printexc.to_string e) line ;
          failwith "from_money_file"

    with End_of_file -> (l_name, l_amount) in 

  (* on récupère les listes de noms et de montant *)
  let (l_name,l_amount) = loop_file [] [] in  

  close_in infile ;

  (* on récupère les paramètres importants pour la suite :
     - nombre de personnes
     - montant total
     - moyenne = montant que chaque personne doit payer *)
  let nb_person = List.length l_amount in
  let total_amount = sum_list l_amount in
  let average_amount = total_amount / nb_person in

  let rec loop_graph graph n l = match l with
    | [] -> graph
    | amount::rest -> let graph2 = new_node graph n in
      let diff_amount = (amount-average_amount) in
      let graph3 = if diff_amount > 0
      (*vers le sink s'il doit être remboursé *)
        then new_arc graph2 n (nb_person + 1) diff_amount 
        (*vers la source s'il doit de l'argent *)
        else (if diff_amount < 0
              then new_arc graph2 0 n (-diff_amount) 
              else graph2) in
      loop_graph graph3 (n+1) rest in 

  (* on rajoute un noeud à notre graphe qui correspond au départ *)
  let start_graph = new_node empty_graph 0 in
  (* on rajoute un noeud à notre graphe qui correspond au sink *)
  let start_graph = new_node start_graph (nb_person + 1) in 
  (* on rajoute un noeud par personne et on les relie au départ ou au sink *)
  let graph = loop_graph start_graph 1 l_amount in 


  (* on relie le noeud à tous les autres noeuds et on met un label infini *)
  let rec loop2_inter_graph x y graph = match y with
    | 0 -> graph
    | _ -> loop2_inter_graph x (y-1) (new_arc graph x y max_int) in

  (* pour chaque noeud interne on doit le relier aux autres noeuds *)
  let rec loop_inter_graph n graph = match n with
    | 1 -> graph
    | _ -> let graph2 = (loop2_inter_graph n (n-1) graph) in
      loop_inter_graph (n-1) graph2 in

  (loop_inter_graph nb_person graph,l_name)

let export_money path graph l_name =
  (* Open a write-file. *)
  let ff = open_out path in
  let nb_person = List.length l_name in
  (* convertit un id en une string qui correspond au nom de la personne *)
  let string_of_id id = List.nth l_name (id-1) in

  (* Write in this file. *)
  fprintf ff "digraph finite_state_machine {\n\trankdir=LR;\n\tsize=\"8,5\"\n\tnode [shape = circle];\n";

  (* Write all arcs *)
  e_iter graph (fun id1 id2 lbl -> 
      (* on n'affiche pas les arcs de départ et de sink qui servent uniquement à l'algo et on affiche seulement un seul des 2 arc celui avec le label positif  *)
      if id1=0 || id1=(nb_person+1) || id2=0 || id2=(nb_person+1) || (max_int-lbl)<=0
      then () 
      else fprintf ff "\t%s -> %s [ label = \"%d\" ];\n" (string_of_id id1) (string_of_id id2) (max_int-lbl)) ;
  fprintf ff "}\n";

  close_out ff;
  ()

