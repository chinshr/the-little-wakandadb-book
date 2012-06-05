## About This Book ##

### License ###
The Little WakandaDB Book book is licensed under the Attribution-NonCommercial 3.0 Unported license. **You should not have paid for this book.**

You are basically free to copy, distribute, modify or display the book. However, I ask that you always attribute the book to me, Juergen Fesslmeier and do not use it for commercial purposes.

You can see the full text of the license at:

<http://creativecommons.org/licenses/by-nc/3.0/legalcode>

### About The Author ###

### With Thanks To ###

[David Robbins](http://example.com)

[Dave Terry](http://example.com)

[Melinda Gallo](http://example.com)

This book has been inspired by Karl Seguin's book [The Little MongoDB Book](https://github.com/karlseguin/the-little-mongodb-book/).

### Latest Version ###
The latest source of this book is available at:

<https://github.com/chinshr/the-little-wakandadb-book>

\clearpage

## Introduction ##

## Getting Started ##

## Chapter 1 - The Basics ##

### Datastore Classes

Datastore classes are similar to the concept of defining a schema for a table in traditional SQL databases.

In the example we are about to build, we want to create an object model around a University with teachers, students, and courses. I.e. Students attend courses and Teachers teachers teach courses. This should be easy enough to explain the concept of classes.

We will start by creating a new datastore class called `Student`. This class will store all student instances, which are also referred to as entities.

    ds.Class.create("Student", attributes: {
      first: "string",
      last:  "string"
    });

We create a new student entity.

    ds.Student.create({first: "Sean", last: "Parker"});

You can now query this student as follows.

    ds.Student.find("last = 'Parker'")
    => {ID: 1, first: "Sean", last: "Parker"}

## Chapter 2 - Attributes ##

Attributes would refer to columns in the traditional table based databases. Each attribute can be of a simple, or scalar types. The built in scalar types in WakandaDB today are `number`, `string`, `byte`, `date`, `word`, `long64`, `uuid`, `duration`, `image`, `blob`.

### Storage Attributes

All attributes made of scalar types are simply referred to as storage attributes, like attributes `first` and `last` in a new datasource class `Teacher` we are about to define now.

    ds.Class.create("Teacher", attributes: {
      first:     {type: "string"},
      last:      {type: "string"},
      createdAt: {type: "Date"},
      updatedAt: {type: "Date"}
    });

We are now ready to start creating a teacher instance.

    var albert = new Teacher({first: "Albert", last: "Einstein"});
    albert.save();
    
Notice, that the `createdAt` and `updatedAt` are automatically populated with the current date and time as soon as the instance is created and later be  updated.

### Calculated attributes
Calculated attributes are the result of a storage attribute combining one, two ore more storage attributes together. There are different events that can be associated depending on how this attribute is used: `onGet`, `onSet`, `onQuery`, `onSort`.

Let's say in the teacher datastore class we want to receive a concatenation of  `first` and `last` name by simply calling attribute `name` on the instance. So let's extend class `Teacher` and add a new `name` attribute with `onSet` event like the following: 

    ds.Teacher.extend(attributes: {
      name: {
        onGet: function() {
          return this.first + this.last;
        }
      }
    });

In order to retrieve the full name we call the name attribute on the teacher's instance:

    albert.name;
    => "Albert Einstein"

### Relation attributes
E.g. teacher attribute on Course of type Teacher

### Alias attributes
E.g. "studentName" theStudent.fullName

## Chapter 2 - Updating ##

## Chapter 3 - Mastering Find ##

## Chapter 4 - Data Modeling ##

## Chapter 5 - Performance and Tools ##

## Conslusion
