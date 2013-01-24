Technical Debt
--------------

Cover the technical debt and consider the architecture and flexibility of the project.

  * Remove duplication from cucumber scenarios
  * Review architecture of defining and undefining a plugin
  * Refactor configuration settings so that they are accessible to all instances of Nark.
  * Contain plugin functionality instead of blindly injecting them into Nark
  * Decrease the use of eval in general
    * I don't know how to improve this yet.
