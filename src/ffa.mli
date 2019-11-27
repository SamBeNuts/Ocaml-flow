open Graph

(* Ford Fulkerson algorithm, returns an int graph as a gacaparev *)
val ffa: int graph -> id -> id -> int graph

(* Find a path beetween 2 nodes (depth-first) and return the node list *)
val path: int graph -> id -> id -> id list

(* Return an int graph with double edges : (capacity - flow) both ways *)
val create_gcaparev: int graph -> int graph

(* Takes a ffa graph output and merges double edges from gcaparev *)
val clean: int graph -> int graph -> int graph
