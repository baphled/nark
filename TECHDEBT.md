Technical Debt
--------------

Cover the technical debt and consider the architecture and flexibility.

* Remove duplication from cucumber scenarios
* Clean up after myself when writing specs
* Review architecture of plugin (un)defintion
* Contain plugin functionality instead of blindly injecting them into Nark
* Decrease the use of eval in general
  * I don't know how to improve this yet. 
* Review the need for a after_response hook
  * Starting to think there should only be two hooks in the middlewars call
