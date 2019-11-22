open Graph
open Tools

let rec print_list = function 
    [] -> print_string "\n"
  | e::l -> print_int e ; print_string " " ; print_list l



let path g idd idf = 

  let rec add_path path_head path_tail = function
    | [] -> []
    | (id,lbl)::tl -> if lbl>0 
      then (id::path_head::path_tail)::(add_path path_head path_tail tl) 
      else add_path path_head path_tail tl

  in let rec add_node acu = match acu with
      | [] -> []
      | (path_head::path_tail)::acu_tail ->
        if List.exists (fun x -> x=path_head) path_tail
        then add_node acu_tail
        else (if path_head = idf 
              then List.rev (path_head::path_tail) 
              else add_node (List.append (add_path path_head path_tail (out_arcs g path_head)) acu_tail))
      | []::_ -> raise (Graph_error "add_node []::_")

  in add_node [[idd]]

let create_gcaparev g = e_fold g (fun gr id1 id2 lbl -> new_arc gr id2 id1 (if lbl = 1000 then 1000 else 0)) g 

let min_list g l =
  let rec aux l acc = match l with
    | [] -> acc
    | idd::(idf::rest) -> begin match (find_arc g idd idf) with 
        | Some lbl -> aux (idf::rest) (if lbl < acc then lbl else acc)
        | None -> raise (Graph_error "min_list")
      end
    | idf::rest -> acc
  in aux l max_int

let rec ajout_flux g chemin ajout = match chemin with
  | [] -> g
  | idd::(idf::rest) ->
    let g2 = add_arc g idf idd ajout in
    let g3 = add_arc g2 idd idf (-ajout) in
    ajout_flux g3 (idf::rest) ajout
  | idf::rest -> g

let ffa gcapa ids idf =
  (*on initialise le graphe de flow à 0*)
  let gcaparev = create_gcaparev gcapa

  in let rec loop g ids idf =
       let chemin = path g ids idf in
       (*condition de fin, flow max*)
       if (List.length chemin)=0
       then g
       else let min = min_list g chemin in
         print_string "min: ";
         print_int min;
         print_string "\n";
         print_list chemin;
         loop (ajout_flux g chemin min) ids idf
  in loop gcaparev ids idf;;