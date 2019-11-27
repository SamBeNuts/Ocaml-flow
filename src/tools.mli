open Graph

(*returns a new graph having the same nodes than gr, but no arc*)
val gmap: 'a graph -> ('a -> 'b) -> 'b graph

(*maps all arcs of gr by function f*)
val clone_nodes: 'a graph -> 'b graph

(*adds n to the value of the arc between id1 and id2. If the arc does not exist, it is created*)
val add_arc: int graph -> id -> id -> int -> int graph

(* debug function *)
val print_list: int list -> unit

(* adds element of an int list, used by money.ml *)
val sum_list: int list -> int