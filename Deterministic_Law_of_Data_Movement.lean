import Std.Data.HashSet.Lemmas
-- 1. FUNDAMENTAL STRUCTURES
structure Window where
  start_t : Float
  end_t   : Float
  rate    : Float

structure LunarNode where
  name : String
  capacity : Float

structure Reservation where
  start_t : Float
  end_t   : Float
  size    : Float

-- 2. ENGINES (Mirroring Python Model) 
def integrated_capacity (ws : List Window) (current_t : Float) : Float :=
  ws.foldl (init := 0.0) (fun acc w => 
    if w.end_t > current_t then
      let actual_start := if w.start_t > current_t then w.start_t else current_t
      acc + (w.end_t - actual_start) * w.rate
    else acc)

def occupancy_at (res : List Reservation) (t : Float) : Float :=
  res.foldl (init := 0.0) (fun acc r => 
    if r.start_t <= t && t < r.end_t then acc + r.size else acc)

-- 3. STATUS DEFINITION 
inductive DeliveryStatus where
  | Ensured
  | Rejected (reason : String)
  deriving DecidableEq

-- 4. THE PROOF 
theorem lunar_delivery_ensurance 
  (file_size : Float) 
  (ws : List Window) 
  (node : LunarNode) 
  (res : List Reservation) 
  (now : Float) 
  (h_flux : file_size <= integrated_capacity ws now)
  (h_safe : occupancy_at res now + file_size <= node.capacity) :
  (if (file_size <= integrated_capacity ws now) && (occupancy_at res now + file_size <= node.capacity) 
   then DeliveryStatus.Ensured 
   else DeliveryStatus.Rejected "Violation") = DeliveryStatus.Ensured :=
by
  -- Combine the hypotheses into a single boolean proof term
  let condition_proof : (file_size <= integrated_capacity ws now) && (occupancy_at res now + file_size <= node.capacity) := 
    by simp [h_flux, h_safe]
  
  -- Rewrite using the proof that the condition is true
  rw [if_pos condition_proof]

-- 5. PATH DEFINITION
structure Hop where
  target_node : LunarNode
  windows     : List Window
  reservations: List Reservation

-- We explicitly define Path as a List Hop so Membership (∈) works
abbrev Path := List Hop

-- 6. RECURSIVE CHECK (The Hydraulic Chain)
def check_path_ensurance (file_size : Float) (now : Float) : Path → Bool
  | [] => true
  | h :: t => 
    let flux_ok := file_size <= integrated_capacity h.windows now
    let safe_ok := occupancy_at h.reservations now + file_size <= h.target_node.capacity
    -- Boolean AND (&&) requires both local conditions to be true to continue
    if flux_ok && safe_ok then
      check_path_ensurance file_size now t 
    else false

-- 7. THE INDUCTIVE THEOREM 
theorem path_delivery_induction
  (file_size : Float)
  (now : Float)
  (p : Path)
  (h_all_hops : check_path_ensurance file_size now p = true) :
  ∀ (hop : Hop), hop ∈ p → 
    (file_size <= integrated_capacity hop.windows now) ∧ 
    (occupancy_at hop.reservations now + file_size <= hop.target_node.capacity) :=
by
  induction p with
  | nil => 
    intro hop h_mem
    nomatch h_mem
  | cons head tail ih =>
    intro hop h_mem
    -- 1. Unfold and simplify the function logic
    simp [check_path_ensurance] at h_all_hops
    -- 2. Extract the head and tail proofs
    let ⟨h_head_valid, h_tail_ensured⟩ := h_all_hops
    
    -- 3. Explicitly handle the membership cases
    match h_mem with
    | List.Mem.head _ => 
      -- The hop is the head; h_head_valid contains the flux and safety proofs
      exact h_head_valid
    | List.Mem.tail _ h_tail_mem => 
      -- The hop is in the tail; 'h_tail_mem' is now explicitly bound
      exact ih h_tail_ensured hop h_tail_mem