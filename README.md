# flutter_first_app

First time on Flutter, so time to play !!

I am referring to this project:
https://codelabs.developers.google.com/codelabs/flutter-codelab-first?hl=fr#2

You will find a looot of comments in main.dart, as I use this project
to understand the Dart syntax and the Flutter running.

## Getting Started

CLI: Flutter run and r for hot reload
(the application state is not lost during the reload. To reset the state, use hot restart instead)
You can use F5 or run & debug icon, as well.

Target device can be changed first at the screen bottom.
This project is checked on Chrome for desktop & Galaxy S9 for mobile.

## About Dart

### Typed language

Type is announced before the variable

### Null-safe language

So we have to use specifics operators and syntax.
Remind :

- ?? is a null operator -> this operator returns expression on its left,except if it is null, and if so, it returns right expression ;
- ! is a bang operator to inform the compiler that even if the variable is a nullable type, the value won't be null ;
- ? after a type means that it can have a null value ;
- late keyword is used to indicate that a non-nullable variable will be initialized later in the code ;
