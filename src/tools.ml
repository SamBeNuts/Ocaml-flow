open Graph

let clone_nodes g = n_fold g new_node empty_graph;;

let gmap g f = e_fold g (fun gr id1 id2 lbl -> new_arc gr id1 id2 (f lbl)) (clone_nodes g);;

let add_arc g id1 id2 n = let lbl = find_arc g id1 id2 in new_arc g id1 id2 (match lbl with | Some i -> i+n | None -> n);;