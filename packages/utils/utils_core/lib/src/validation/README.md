# Validation

There are many instances where you want to validate that a value passes a certain test. For example, checking that a value is not null, a String represents a positive integer, a String is an email, an int is positive, etc.

The `Validation` package provides many of these functionalities, along with utilities for transforming and grouping, so that you can define your libraries with Validators instead of arbitrary validation functions.

A `Validator` contains an input type (the type of object it is validating) and an error type (the type of the error it will produce if it is not validated).

Validation logic is easy to follow, so feel free to see the examples in `validator.dart`.
