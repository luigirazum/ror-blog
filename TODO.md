# Blog app: add authorization rules

## Learning objectives
- Limit access to web app resources based on authorization rules.

## Description
In this project, you will add authorization to your app using [CanCanCan](https://github.com/CanCanCommunity/cancancan).

*IMPORTANT NOTE: Read **all** requirements before you start building your project.*

### Project requirements
- [ ] Install CanCanCan in your project.
- [ ] Add a `role` column to the users table. Remember to use a migration for this.
- [ ] A user can delete a post if it is theirs or if they have an admin role (column `role` has value `"admin"`). Use CanCanCan for this authorization.
  - [ ] For that you need to implement the post deleting functionality. Add the "Delete" button to the view and make sure that only authorized users can see it.
- [ ] A user can delete a comment if it is theirs or if they have an admin role (column `role` has value `"admin"`). Use CanCanCan for this authorization.
  - [ ] For that you need to implement the comment deleting functionality. Add the "Delete" button to the view and make sure that only authorized users can see it.
