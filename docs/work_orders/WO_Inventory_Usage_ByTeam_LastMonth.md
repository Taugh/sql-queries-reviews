# Inventory Usage by Maintenance Team — Last Month (Requisition-Based)

**Purpose**  
Report last month’s material requisitions attributed to maintenance teams, by linking MR/MRLINE to Work Orders.

**Row Grain**  
One row per `MRLINE`.

**Time Window**  
- Start: first day of previous month (inclusive)  
- End: first day of current month (exclusive)

**Filters**
- `MR.SITEID = 'FWN'`
- `MR.STATUS NOT IN ('CAN','DRAFT')`
- Team ∈ configured groups via `WO.ASSIGNEDOWNERGROUP` **or** `WO.OWNERGROUP`

**Key Joins**
- `MRLINE` → `MR` on `(MRNUM, SITEID)`  
- `MRLINE` → `WORKORDER` on `(REFWO = WONUM, SITEID)`

**Output Columns**  
Requisition, Requisition Description, Requested By, Requested For, Requested Date, Status, Site, Work Order, Item Line #, Item #, Item Description, Quantity, Unit Cost, Line Cost, Assigned Owner Group, Owner Group.

**Performance Notes**  
- SARGable month boundaries; no functions on filtering columns.  
- Consider indexes:
  - `mr (siteid, enterdate, status, mrnum, wonum)`
  - `mrline (siteid, mrnum, refwo, mrlinenum, itemnum) INCLUDE (qty, unitcost, linecost)`
  - `workorder (siteid, wonum, assignedownergroup, ownergroup)`

**Change Log**  
- 2025‑09‑04: Initial refactor added with site‑safe joins and documentation.
