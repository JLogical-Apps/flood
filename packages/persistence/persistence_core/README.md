# Persistence (Core)

This package exports utilities that help with persisting and retrieving data.

## Data Sources

There are many locations where you need to save and retrieve data. For example, a text file can contain some String data, a binary file can contain a list of bytes, a Directory can contain a list of files, a Flutter asset can contain yaml, etc.

`Persistence` defines `DataSource`s which allow you to retrieve and save data to a location easily, and also provides utilities to transform the mapped data.

This package does not have any Flutter dependencies, so you can use it in CLI tools. Take a look at [Persistence](../persistence/README.md) (not core) to see some extensions which provide DataSources in a Flutter-specific context.

## DataSource

A DataSource standardizes checking whether data exists, retrieving the data, listening to the data, setting the data, and deleting the data with the following methods:

- `getX()`: Returns a Stream of data from the DataSource.
- `getOrNull()`: Returns the current data in the DataSource, or `null` if it doesn't exist.
- `exists()`: Returns whether the DataSource exists.
- `set(data)`: Sets the value of the DataSource to `data`.
- `delete()`: Deletes the DataSource.

For example, consider `final fileDataSource = DataSource.static.file(myFile)`. You can listen to the contents of the file using `fileDataSource.getX().listen(...)`, you can write to the file using `fileDataSource.set('myString')`, or delete the file using `fileDataSource.delete()`.

DataSources come in very handy since you don't have to memorize or lookup how to retrieve/save/delete data for the various data sources out there. You can simply find the right DataSource and use the standardized methods easily.

## Transforming Data Sources

You can map data from a DataSource to another format. For example, if you have a file `settings.json`, you may not care about the actual String contents of the file, you may just want the Map<String, dynamic> representation of the json. You can easily do this by using `final jsonSettingsDataSource = DataSource.static.file(mySettingsFile).mapJson()`. Now, if you call `await jsonSettingsDataSource.getOrNull()`, it will return a Map<String, dynamic> instead of a String, and you can update the data in the file using a Map<String, dynamic> instead of encoding it to a json String first.
