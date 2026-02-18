# Exercise 01 - Add New User (Provider)

Goal: practice UI composition + provider state updates.

## What is already prepared

- `List` tab has an `Add user` button.
- Button opens a bottom sheet with a user form.
- Bottom sheet has a `Save user` button.
- `UsersProvider` has an `addUser(UserEntity user)` method with a TODO.

## Tasks

1. Implement `addUser` in:
- `lib/providers/users_provider.dart`

Expected behavior:
- Insert the new user into `_users`.
- Call `notifyListeners()`.

2. Connect the save action in:
- `lib/pages/users_list_tab.dart`

Expected behavior:
- In the bottom sheet `Save user` button, call:
- `context.read<UsersProvider>().addUser(nextUser);`
- Close the sheet.
- Show the new user in the `List` tab.

3. Optional validation improvements
- Prevent saving if `name`, `username`, or `email` are empty.
- Show error feedback with `SnackBar`.

## Bonus

4. Add widget test for adding user

Create a test that verifies:
- Tap `Add user`.
- Fill form fields.
- Tap `Save user`.
- New user appears in list.

Suggested file:
- `test/widget_test.dart`
