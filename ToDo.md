# Introduction #

This is just a simple ToDo list


# Details #

  * Attachments (**Christian**)(**DONE**)
    * Use GOS object to store attachements into Bug Id (**DONE**)
    * Create ALVGrid in Attachement tabStrip in order to display attachements list (**DONE**)

  * ENQUEUE and DEQUEUE
    * Create Lock/Unlock in all entities in order to avoid parallel object edition

  * changeLog
    * Develop SAPChangeDocuments in order to trace ALL changes in any filed of BUG entity and also in all it's dependent entities.

  * Send Mail (**Christian**)
    * on change, inform the different users (reporter, tester, developer, assigned) about changes
    * depend/respect on the status

  * Build Time Reporting solution (**Jorge**)
    * Create custo Master table in order to add concepts, so that workLog could be invested in "design", or "implementation" or "testing" or... anything else.
    * Create ALVGrid in Time Reporting tabStrip where all the Work Log will be displayed by Bug Id (also "added" from here)

  * Fix popup "Data has been changed" (**Jorge**, **DONE**)

  * Fix ALVTree where bug hierarchy
    * Fix [issue 1](https://code.google.com/p/sapbugtracker/issues/detail?id=1)

  * information system(**WORKING**)
    * Bugs opened by me
    * Bugs assigned to me
    * Bugs where I'm a tester
    * Bugs by status
    * Work Log by User/users/time period/Bug

  * TR list
    * List Bugs by Transport Request
    * List Bugs by transport requests imported into system XXX

  * TR the popup
    * Ask for bug Id when adding objects into a Transport request