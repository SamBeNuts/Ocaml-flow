open Graph

(* creates a graph and a list of names from an input file *)
val from_money_file: string -> int graph * string list

(* make a file than can be converted to svg without the source and sink *)
val export_money: string -> int graph -> string list -> unit