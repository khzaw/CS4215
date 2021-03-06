(*   Week 3 Lab : OCaml Refresher  *)
(* Please submit by 6pm 4thFebruary *)


(* LISTS *)

(* Implement a function that would return the 
   2nd last element. For example:
      last_two [1;2;3;4;5] ===> Some 4
      last_two [5] ===> None
*)
let rec last_two (xs:'a list) : 'a option = match xs with
  | [] -> None
  | [_] -> None
  | [x; _] -> Some x
  | x::xs -> last_two xs
;;

last_two [ 'a' ; 'b' ; 'c' ; 'd' ];;
(* val last_two : 'a list -> 'a option = <fun> *)
(* - : char option = Some 'c' *)
 
let ls2 = [`a;`a;`a;`a;`b;`c;`c;`a;`a;`d;`e;`e;`e;`e];;

(* Implement a function that would remove
   duplicates that occur consecutively.
   For example:
      compress [1;1;2;2;1] ==> [1;2;1]
*)
let rec compress (xs:'a list) : 'a list = match xs with
  | x :: (y :: ys as t) -> if x = y then compress t else x :: (compress t)
  | others -> others
;;

compress ls2;;
(* val compress : 'a list -> 'a list = <fun> *)
(* - : [> `a | `b | `c | `d | `e ] list = [`a; `b; `c; `a; `d; `e] *)

(* Implement a function that would remove
   all duplicates in a list.
   For example:
      removeDupl [1;1;2;2;1] ==> [1;2]
*)
let rec removeDupl (xs:'a list) : 'a list =  match xs with
  | [] -> []
  | hd :: tl -> hd :: (removeDupl (List.filter (fun x -> x <> hd) tl))
;;

removeDupl ls2;;
(* val removeDupl : 'a list -> 'a list = <fun> *)
(* - : [> `a | `b | `c | `d | `e ] list = [`a; `b; `c; `d; `e] *)

let ls3 = [3;6;7;3;4;8;3;3;3];;

(* Implement a function that would return the
   first element in a list that satisfies a given predicate
   For example:
      findFirst (fun x -> x>1) [1;1;2;1;4;1] ==> Some 2
      findFirst (fun x -> x>4) [1;1;2;1;4;1] ==> None
*)
let findFirst (p:'a->bool) (xs:'a list) : 'a option =
  let rec aux xs =
    match xs with
      | [] -> None
      | y::ys ->
        if p y then Some y
        else aux ys
  in aux xs
;;

findFirst (fun x -> x mod 2 = 0) ls3;;
(* val findFirst : ('a -> bool) -> 'a list -> 'a option = <fun> *)
(* - : int option = Some 6 *)

(* Implement a function that would return the
   last element in a list that satisfies a given predicate
   For example:
      findLast (fun x -> x>1) [1;1;2;1;4;1] ==> Some 2
      findLast (fun x -> x>4) [1;1;2;1;4;1] ==> None
*)
let rec findLast (p:'a->bool) (xs:'a list) : 'a option =
  let rec aux ans xs =
    match xs with
      | [] -> ans
      | y::ys -> 
        if p y then aux (Some y) ys
        else aux ans ys
  in aux None xs
;;

findLast (fun x -> x mod 2 = 0) ls3;;
(* val findLast : ('a -> bool) -> 'a list -> 'a option = <fun> *)
(* - : int option = Some 8 *)

(* Given a number n>1, generate all possible
   pairs of positive numbers (a,b) such that n=a+b 
   For example:
     genPairs 3 ===> [(1,2);(2;1)]
*)

let genPairs (n:int) : (int * int) list =
  let rec aux x acc = if x = n then List.rev acc
                      else aux (succ x) ((x, (n - x)) :: acc)
  in aux 1 []
;;

genPairs 6;;

(* val genPairs : int -> (int * int) list = <fun> *)
(* - : (int * int) list = [(1, 5); (2, 4); (3, 3); (4, 2); (5, 1)] *)

(* NUMBERS *)

(* Given a number n, return true if it is a prime number
   otherwise return false
     isPrime 2 ==> true
     isPrime 4 ==> false
*)
let isPrime (n:int) : bool =
  let sqrt_n = truncate (sqrt (float n)) in
  let rec helper k = 
    if k<=1 then true
    else if n mod k==0 then false
      else helper (k-1) in
  helper sqrt_n;;

isPrime 13;;
(* val isPrime : int -> bool = <fun> *)
(* - : bool = true *)

(* 
   Given a range of integers by its lower and upper limit, 
   construct a list of all prime numbers in that range. 
   For example:
      allPrimes 10 2 ==> []
      allPrimes 2 10 ==> [2;3;5;7]
*)

let allPrimes (x:int) (y:int) : int list =
  let rec aux lower upper acc = 
    if lower > upper then List.rev acc
    else if (isPrime lower) then aux (succ lower) upper (lower::acc) 
         else aux (succ lower) upper acc 
  in aux x y []
;;

allPrimes 1 100;;
(* val allPrimes : int -> int -> int list = <fun> *)
(* - : int list = *)
(* [1; 2; 3; 5; 7; 11; 13; 17; 19; 23; 29; 31; 37; 41; 43; 47; 53; 59; 61; 67; 71; 73; 79; 83; 89; 97] *)

(* 
    Given a number, return its prime factors.
    For example:
      pfactors 6  ==> [2;3]
      pfactors 12 ==> [2;2;3]
*)

let pfactors (n:int) : int list =
  let rec aux divisor n =
    if n = 1 then []
    else if (n mod divisor = 0) then divisor :: aux divisor (n/divisor) else aux
      (succ divisor) n 
  in aux 2 n
;;

pfactors 315;;
(* val pfactors : int -> int list = <fun> *)
(* - : int list = [3; 3; 5; 7] *)

(* 
    Given a number, return a list of 
     unique prime factors and their occurrences.
    For example:
      pfactorsM 6  ==> [(2,1);(3,1)]
      pfactorsM 12 ==> [(2,2);(3,1)]
*)

(* let group xs = *)
  (* let rec group_aux = function *)
    (* | [] -> [] *)
    (* | [x] -> [[x]] *)
    (* | x :: xs -> *)
        (* let ((y :: _) as ys) :: yss = group_aux xs in *)
        (* if x = y then (x :: ys) :: yss else [x] :: ys :: yss *)
  (* in group_aux xs *)
(* ;; *)

let pfactorsM (n:int) : (int * int) list =
  let factors = pfactors n in
  let tuplize xs = (List.hd xs, List.length xs) in
  let group xs =
    let groups =
    List.fold_left (fun acc x -> match acc with
      | [] -> [[x]]
      | hd :: tl -> if (List.hd hd) = x then (x::hd)::tl else [x]::hd::tl) [] xs
    in match groups with
    | [] -> []
    | l -> List.rev l
  in List.map (tuplize) (group factors)
;;

  (* let rec aux current count acc = function *)
    (* | [] -> acc *)
    (* | hd::tl ->  *)
        (* if hd=current then aux current (succ count) acc tl *)
        (* else (match tl with  *)
        (* | [] -> [] *)
        (* | x::xs -> aux x 0 ((current, count)::acc) xs) in *)
  (* match factors with *)
  (* | [] -> [] *)
  (* | hd::tl -> aux hd 1 [] tl *)
(* ;; *)

pfactorsM 315;;
(* val pfactorsM : int -> (int * int) list = <fun> *)
(* - : (int * int) list = [(3, 2); (5, 1); (7, 1)] *)

(*
   Goldbach's conjecture says that every positive even number greater 
   than 2 is the sum of two prime numbers. Example: 28 = 5 + 23. It is 
   one of the most famous facts in number theory that has not been proved 
   to be correct in the general case. It has been numerically confirmed 
   up to very large numbers. Write a function to find the two prime 
   numbers that sum up to a given even integer.
   For example:
      goldbach 4 ==> (2,2)
      goldbach 8 ==> (3,5)
*)
let goldbach (n:int) : (int*int) =
  let rec aux p =
    if isPrime p && isPrime (n-p) then (p, n-p)
    else aux (succ p)
  in aux 2
;;

goldbach 28;;
(* val goldbach : int -> int * int = <fun> *)
(* - : int * int = (5, 23) *)


(* TREES *)


type 'a tree = Leaf of 'a | Node of 'a * ('a tree) * ('a tree)

let bt1 = Node (1,(Leaf 2),Node (3,(Leaf 4),(Leaf 5)));;

(*
   Write a function that would count the number of leaves
   in a given binary tree
   For example:
     countL (Leaf 0) ==> 1
     countL (Node(0,(Leaf 0),Node(0,Leaf 0,Leaf 0))) ==> 3
*)
let rec countL (t:'a tree) : int =
  match t with
  | Leaf _ -> 1
  | Node (_, left, right) -> (countL left) + (countL right)
;;

countL bt1;;
(* val countL : 'a tree -> int = <fun> *)
(* - : int = 3 *)

(* 
   We can flatten a tree into a list in prefix fashion
   by putting value at node, then values of left subtreee,
   followed by values of right subtrees.
   For example:
     prefixBT (Node(4,Leaf 1, Leaf 2)) ==> [4;1;2]
*)

let rec prefixBT (xs:'a tree) : 'a list =
  match xs with
  | Leaf x -> [x]
  | Node (x, left, right) -> List.concat [[x]; (prefixBT left); (prefixBT right)]
;;

prefixBT bt1;;
(* val prefixBT : 'a tree -> 'a list = <fun> *)
(* - : int list = [1; 2; 3; 4; 5] *)

(* 
   We can flatten a tree into a list in infix fashion
   by putting values of left subtreee, value at node,
   followed by values of right subtrees.
   For example:
     infixBT (Node(4,Leaf 1, Leaf 2)) ==> [1;4;2]
*)
let rec infixBT (xs:'a tree) : 'a list =
  match xs with
  | Leaf x -> [x]
  | Node (x, left, right) -> List.concat [(infixBT left); [x]; (infixBT right)]
;;

infixBT bt1;;
(* val infixBT : 'a tree -> 'a list = <fun> *)
(* - : int list = [2; 1; 4; 3; 5] *)

(* A tree is perfectly balanced if either it is a leaf
   or it is a node with two subtrees of the same height and also
   perfectly balanced. Write a function that takes a height
   value and then returning a perfect tree of that height with 
   all its elements set to 1 
  For example:
    perfectTree 2 ==> Node (1, Leaf 1, Leaf 1)
*)
let perfectTree n =
  let rec aux = function
    | n when n = 1 -> Leaf 1
    | n -> Node(1, aux (pred n), aux (pred n))
  in aux n
;;

perfectTree 3;;
(* val perfectTree : int -> int tree = <fun> *)
(* - : int tree = Node (1, Node (1, Leaf 1, Leaf 1), Node (1, Leaf 1, Leaf 1)) *)



(* HIGHER-ORDER *)

(* 
   Given two lists, return a list of all possible
   pairs of the two lists.
   For example prod [1;2] [`a;`b] would
   return [(1,`a);(1,`b);(2,`a);(2,'b)]
   Use higher-order List.map to help you in this task.
*)

let rec prod (xs:'a list) (ys:'b list) : ('a * 'b) list =
  []
;;

prod [1;2] [`a;`b;`c];;
(* val prod : 'a list -> 'b list -> ('a * 'b) list = <fun> *)
(* [(1, `a); (1, `b); (1, `c); (2, `a); (2, `b); (2, `c)] *)

(* polymorphic rose tree *)
type 'a roseTree = 
  | NodeR of 'a * (('a roseTree) list)

let rt2 = NodeR (1,[NodeR (2,[]);NodeR (3,[NodeR(4,[])]);NodeR(5,[])]);;

(* 
   We can flatten a rosetree into a list in prefix fashion
   by putting value at node, followed by values of each 
   of the subtrees.
   Implement a first-order version of this prefixRT
   method without using any higher-order functions.
   For example:
     prefixRT (NodeR(4,[NodeR (1,[]); NodeR (2,[])]))  ==> [4;1;2]
   Below is a first-order implementation.
*)

let rec prefixRT (xs:'a roseTree) : 'a list =
  match xs with
    | NodeR (x,lrt) -> x :: comb_prefixRT lrt

and comb_prefixRT (xs:('a roseTree) list) : 'a list =
  match xs with
    | [] -> []
    | x::xs -> (prefixRT x)@comb_prefixRT xs;;

prefixRT rt2;;
(* val comb_prefixRT : 'a roseTree list -> 'a list = <fun> *)
(* - : int list = [1; 2; 3; 4; 5] *)

prefixRT (NodeR(4,[NodeR (1,[]); NodeR (2,[])]));;

(* 
   write a higher-order counterpart for prefixRT 
   Use higher-order function List.fold_right to help
   you in this method.
*)
let rec prefixRTHO (xs:'a roseTree) : 'a list =
  []
;;


prefixRTHO rt2;;
(* val prefixRTHO : 'a roseTree -> 'a list = <fun> *)
(* - : int list = [1; 2; 3; 4; 5] *)

(* 
   write a higher-order counterpart for postfixRT 
   Use higher-order function List.fold_right to help
   you in this method.
*)
let rec postfixRTHO (xs:'a roseTree) : 'a list =
  []
;;

postfixRTHO rt2;;
(* val postfixRTHO : 'a roseTree -> 'a list = <fun> *)
(* - : int list = [2; 4; 3; 5; 1] *)


(* 
   We can denote rose trees as strings of the following form: 
    "a(b(d,e),c,f(g))".
   Write an OCaml function which generates such a string representation
   for rose tree.
   You are to use a higher-order function pr_args below
   which prints a list of items separated by comma.
*)

let pr_args (pr:'a->string) (xs:'a list) : string =
  let rec aux xs =
    match xs with
      | [] -> failwith "pr_args must not have [] input"
      | [x] -> pr x
      | x::xs -> (pr x)^","^(aux xs) 
  in aux xs;;

let rec string_of_RT (pr:'a -> string) (xs:'a roseTree) : string =
  match xs with
    | NodeR (v,ls) ->
          if ls=[] then pr v
          else (pr v)^"("^(pr_args (string_of_RT pr) ls)^")"
;;

print_endline (string_of_RT (string_of_int) rt2);
(* val string_of_RT : ('a -> string) -> 'a roseTree -> string = <fun> *)
(* - : string = "1(2,3(4),5)" *)
