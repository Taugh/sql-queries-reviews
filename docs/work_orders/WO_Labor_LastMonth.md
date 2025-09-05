# WO Labor — Last Month (Transaction Grain)

**Purpose**  
Return last month's labor transactions for work orders in selected owner groups at a specific site, excluding WAPPR/APPR/INPRG.

**Row Grain**  
One row per `labtrans` transaction (laborcode per WO per transaction).

**Time Window**  
- Start: first day of previous month (inclusive)  
- End: first day of current month (exclusive)  
Boundaries computed with `EOMONTH` and no functions applied to indexed columns.

**Filters**
- `w.woclass IN ('WORKORDER','ACTIVITY')`
- `w.istask = 0`
- `w.status NOT IN ('WAPPR','APPR','INPRG')`
- `w.siteid = 'FWN'`
- `w.assignedownergroup IN ('FWNLC1','FWNPS','FWNLC2','FWNMOS')`

**Joins**
- `INNER JOIN labtrans` (only WOs with labor in the window)  
- `LEFT JOIN person` (retain rows with missing display names; fallback to laborcode)

**Output Columns**
Work Order, WO Description, Labor, Name, Site, Group, Work Type, Status, Start Date, Complete Date, Time.

**Performance Notes**
- SARGable date range (`>=` start and `<` next_start)  
- Helpful indexes (if available):
  - `labtrans (siteid, startdatetime, finishdatetime, refwo, laborcode) INCLUDE (regularhrs)`
  - `workorder (siteid, wonum, status, woclass, istask, assignedownergroup, worktype)`
  - `person (personid, locationsite) INCLUDE (displayname)`

**Change Log**
