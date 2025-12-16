# Production Maintenance — Late Work Orders (Completed Last Month)

**Purpose**  
List work orders (CA/PM/RM) completed last month by production maintenance teams that finished late.

**Row Grain**  
One row per Work Order.

**Late Definition**  
`Completed Date` > **earliest** of `Target Completion Date (targcompdate)` and `Finish No Later Than (fnlconstraint)`.  
If one is NULL, use the other; if both NULL, the WO is excluded (no due baseline).

**Completion Window**  
- Start: first day of previous month (inclusive)  
- End: first day of current month (exclusive)  
Completion is determined by the most recent `wostatus` row where `status='COMP'` inside the window.

**Filters**
- Site = `FWN`
- `woclass IN ('WORKORDER','ACTIVITY')`, `istask = 0`
- `worktype IN ('CA','PM','RM')`
- Team ∈ configured groups via AssignedOwnerGroup **or** OwnerGroup

**Output Columns**  
Work Order, Description, Location, Asset, Status, Work Type, Owner Group, Assigned To, Due Date, Finish No Later Than, Completed Date.  
*(Optional: Due Baseline, Days Late — uncomment in SQL if needed.)*

**Performance Notes**  
- SARGable month boundaries; `CROSS APPLY TOP(1)` to get completion date.  
- Suggested indexes:
  - `wostatus (siteid, wonum, status, changedate DESC)`
  - `workorder (siteid, woclass, istask, worktype, assignedownergroup, wonum, targcompdate, fnlconstraint) INCLUDE (owner, status, location, assetnum, actfinish, ownergroup)`

**Change Log**  
- 2025‑09‑04: Initial refactor with accuracy fix for lateness and performance improvements.
