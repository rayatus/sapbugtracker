[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/rayatus/sapbugtracker/blob/master/LICENSE)
![ABAP 7.40sp08+](https://img.shields.io/badge/ABAP-7.40sp08+-brightgreen)
[![Code Statistics](https://img.shields.io/badge/CodeStatistics-abaplint-blue)](https://abaplint.app/stats/rayatus/sapbugtracker)

# SAPBugTracker

Previously in GoogleCode --> https://code.google.com/archive/p/sapbugtracker/

a bugTracker system (like bugZilla) developed in ABAP focused on:

Issue Management, STMS Integration, Time Control

**project for training purposes**

![Display Bug Screen](https://raw.githubusercontent.com/rayatus/sapbugtracker/master/img/SAPBugTracker_display_screen.png)

![Searching for Bugs](https://raw.githubusercontent.com/rayatus/sapbugtracker/master/img/SAPBugTracker_advanced_search_screen.png)

## Characteristics
Info per every single bug is separated into:
- **Info** as: Description, Steps to reproduce and More info.
- **Comments**: allowing to enter comments in a time line.
- **Attachments**: _pending to be developed_.
- **Objects**: It will display the list of all ABAP artifacts (Functions, Classes, etc.) that were changed while working on this bug. This info will be automatically retrieved from the list of objects included in the Transpor Request assigned to this bug ((_pending to be developed_).
- **ChangeLog**: allowing to see how/when changed data from the bug that is being shown (_pending to be developed_).
- **Assign Transport to BUG**: once the corresponding BADI implementation is active and the corresponding Technical Config is in place, a popup will be shown while releasing a Transpor Request allowin to assign it to an existing bug.
- **Tags**: so it could be easy to search for bugs related with a common topi, tags are used (_pending to be developed_).
## Set up
1. execute transaction **ZBUGTRACKER00** to enter configuration menu where you will able to enter:
- Products and components per every single product
- BugTypes and BugSubtypes (like 'Issue / Minor', 'Issue / Critical', 'Enhancement / GAP'...)
- Status and its relation between each one of them (from status A to Status B)
- SAP users and who can be 'Developer', 'Tester'...
- WorkConcepts, for effort estimation (_pending to be developed_).
2. How to assign Transport Requests to an existing bug:
- activate implementation **ZBUGTRACKER**
- next in transaction **ZBUGTRACKER00**, under technical config, assign **configuration type** = 'TRSP Configuration for Transport Popup' by providing for which developers it should be shown and assign either '1 Mandatory' or '2 Optional'.
## How to use it
| transaction | purpose |
|-------------|---------|
| ZBUGTRACKER00 | Provides access to the customizing menu.|
| ZBUGTRACKER01 | Create new bug. |
| ZBUGTRACKER02 | Change existing bug. |
| ZBUGTRACKER02 | Display existing bug. |
| ZBUGTRACKER_SEARCH | Search for existing bugs. |
| ZBUGTRACKER_SEARCH02 | Search for existing bugs according to modification date. |
