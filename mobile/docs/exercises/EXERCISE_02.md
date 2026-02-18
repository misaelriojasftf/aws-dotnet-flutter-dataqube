# Exercise 02 - Add New Cache For Favorites

Option #1

We use the same class user entity and we add a flag to handle favorites

class UserEntity {

  // flag isFavorite;


Option #2

We create a new class for favorites like

class UserFavoriteEntity {

    // String userId;


# Tips

if we create a new Adapter remember applying at the main.dart

if (!Hive.isAdapterRegistered(UserEntityAdapter.kTypeId)) {
    Hive.registerAdapter(UserEntityAdapter());

    // REMEBER ADD NEW ADAPTER HERE
    // Hive.registerAdapter(NewAdapter()); <---
  }

Remember the Repository flow

                |--------> api
entity <----> repo 
                |--------> cache
  


