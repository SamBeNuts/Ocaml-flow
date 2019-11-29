open Graph
open Tools

(* retourne un chemin entre 2 noeuds, le chemin correspond à une liste de noeuds *)
let path g idd idf = 
  let rec add_path path_head path_tail = function
    | [] -> []
    (* si le label n'est pas supérieur à 0 cela veut dire que la capacité max a été atteinte et donc qu'on ne peut pas utiliser cet arc *)
    | (id,lbl)::tl -> if lbl>0 
      then (id::path_head::path_tail)::(add_path path_head path_tail tl) 
      else add_path path_head path_tail tl

  (* on stocke dans acu toutes les possibilité de chemin à étudier *)
  in let rec add_node acu = match acu with
      | [] -> []
      | (path_head::path_tail)::acu_tail ->
        (* si le premier élément du chemin est présent dans la tail de ce même chemin, cela veut dire qu'on est rentré dans une boucle, 
        on passe donc au suivant *)
        if List.exists (fun x -> x=path_head) path_tail
        then add_node acu_tail
        else (if path_head = idf 
              (* un chemin a atteint le noeud destination, on retourne donc ce chemin inversé pour avoir une liste du noeud source au noeud destination *)
              then List.rev (path_head::path_tail) 
              else add_node (List.append (add_path path_head path_tail (out_arcs g path_head)) acu_tail))
      | []::_ -> raise (Graph_error "add_node []::_")
  in add_node [[idd]]

(*  pour chaque arc du graphe on crée un arc dans le sens inversé avec 0 comme label, 
    ça correspondra à notre valeur de flow alors que les arcs déjà existants correspondent à la capacité  *)
let create_gcaparev g = e_fold g (fun gr id1 id2 lbl -> new_arc gr id2 id1 (if lbl = max_int then max_int else 0)) g 

(* on trouve l'arc auquel on peut ajouter le moins de flow et on retourne cette valeur *)
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
  (* on enlève du flux dans le sens de parcours et on ajoute dans le sens opposé *)
  | idd::(idf::rest) ->
    let g2 = add_arc g idf idd ajout in
    let g3 = add_arc g2 idd idf (-ajout) in
    ajout_flux g3 (idf::rest) ajout
  | idf::rest -> g

let rec clean g gcaparev = 
  let find_lbl idd idf = match find_arc gcaparev idd idf with 
    | Some x -> x
    | None -> raise (Graph_error "clean") in
  (* on garde seulement les arcs présents dans notre graphe de départ et on prend le label qui correspond après les changements de flow *)
  e_fold g (fun gr id1 id2 lbl -> new_arc gr id1 id2 (find_lbl id1 id2)) (clone_nodes g)

let ffa gcapa ids idf =
  (*on initialise le graphe de flow à 0*)
  let gcaparev = create_gcaparev gcapa

  in let rec loop g ids idf =
    let chemin = path g ids idf in
    (*condition de fin, flow max*) 
    if (List.length chemin)=0
    then g
    (* si un chemin est trouvé, on ajoute le flow maximal possible à tous les arcs de ce chemin *)
    else let min = min_list g chemin in
      loop (ajout_flux g chemin min) ids idf
  in loop gcaparev ids idf;;