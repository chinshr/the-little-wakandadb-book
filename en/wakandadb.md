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

Wakanda is a development and deployment system for Web based data driven applications. At the heart of every Wakanda application is the data model and as that name would suggest it is the definition of all the data classes,  attributes and relationships. But it is more than that. It is meant to store all your business rules, business logic, everything that is stored in one logical place so that everything interacts with the data model, like classes, or scopes, which control the pieces make it to the browser or events on entities on initialization, or validations when saving an entity. You can define data class methods, which are in essence stored procedures, you can define those as a collection, entity level or class level. You can even used inherited data classes you have a degree of hierachy to the data in your model. You can use restricting queries which control access to entities based on certian conditions you want to set. All of that make up a Wakanda data model. 

## Getting Started ##

## Chapter 1 - The Basics ##

### Datastore Classes

Datastore classes are similar to tables in traditional SQL databases. In the example we are about to build, we want to create an object model around a school with teachers, students, attendance and courses. I.e. Students attend courses and Teachers teachers teach courses. This should be easy enough to explain the concept of the data model.

We will start by creating a new datastore class called `Student`. This class will store all student instances, which are also referred to as entities.

    ds.Class.create("Student", attributes: {
      first: "String",
      last:  "String"
    });

We create a new student entity.

    ds.Student.create({first: "Sean", last: "Smith"});

You can now query this student as follows.

    ds.Student.find("last = 'Smith'")
    => {ID: 1, first: "Sean", last: "Smith"}

## Chapter 2 - Attributes ##

The main thing we are going to show is the four basic kinds of attributes.

We are going to create this from scratch. Let us go through that model, not that complex really. It is a model that is meant that would work for a school: Studdents, teachers, courses, attendence and their grade point. 4 for an A.

Each attendende points to a course and to the student. Ant he course hasa many relation to the teacher.

Let's start, we'll have a new project. For each project you get a new data model. 

Attributes would refer to columns in the traditional table based databases. Each attribute can be of a simple, or scalar types. The built in scalar types in WakandaDB today are `number`, `string`, `byte`, `date`, `word`, `long64`, `uuid`, `duration`, `image`, `blob`.

### Storage Attributes

A storage attribute is exactly what it sounds like, it is similar to database field, it is where information is stored. Storage attributes are of scalar types, so let's define a new data class `Teacher`.

    ds.class.create("Teacher", attributes: {
      first:     {type: "String"},
      last:      {type: "String"},
      createdAt: {type: "Date"},
      updatedAt: {type: "Date"}
    });

Under `Attendee` we add a gradepoint, which is a number.

    ds.class.create("Attendee", attributes: {
      gradePoint: "Number"
    });

For the `Course` 

    ds.class.create("Course", attributes: {
      name: "String",
      semester: "String",
      year: "String"
    });

We are ready to start creating teacher entities.

    // Teacher
    ds.Teacher.create({first: "Sandra", last: "Bowles"});
    ds.Teacher.create({first: "Sam",    last: "Silver"});
    ds.Teacher.create({first: "Dana",   last: "White"});
    ds.Teacher.create({first: "Tim",    last: "Berner"});

So here is what a collection looks like when you query `Teacher`:

    ds.Teacher.query("first: 'S*'");
    => [{ID: 1, first: "Sandra", last: "Bowles"}, {ID: 2, first: "Sam", last: "Silver"}]

If you use a storage attribute on a collection it gives you an array of data based on the attribute you specify.

    var teachers = ds.Teacher.query("first: 'S*'");
    teachers.last;
    => ["Bowles", "Silver"]
    
Note: The `createdAt` and `updatedAt` are automatically populated with the current date and time as soon as the instance is created and later be  updated when it's saved.

### Calculated attributes

Let's extend our model and talk about the next kind of attributes, called calculated attributes.

A typical one would one like full name you know how you design your db and put first and last but you need full name. this way it lests you institutionaliz ethat. full name is not a sotrage attribute. when you have a calcualted attributer the main thing you have to define an onget. that is when nthis attribute is accessed it will return that code.

Calculated attributes are the result of a storage attribute combining one, two ore more storage attributes together. There are different events that can be associated depending on how this attribute is used: `onGet`, `onSet`, `onQuery`, `onSort`.

Let's say in the teacher datastore class we want to receive a concatenation of  `first` and `last` name by simply calling attribute `name` on the instance. So let's extend class `Teacher` and add a new `name` attribute with `onSet` event like the following: 

    ds.Teacher.extend({attributes: {
      name: {
        onGet: function() {
          return this.first + this.last;
        }
      }
    }});

In order to test this try the name calculated attribute on the teacher's instance:
    
    var teacher = ds.Teacher.find("first = 'Tim' AND last = 'Berner'");
    teacher.name;
    => "Tim Berner"

A more interesting example, what if you want to convert your grade point into an alphabetic grade. So instead of grade point 3.33, you want to show letter grade "B+".

    ds.Attendee.extend({attributes: {
      grade: {
        onGet: function() {
          var gp = {0: "F", 1: "D", 1.33: "D+", 1.67: "C-",
            2: "C", 2.33: "C+", 2.67: "B-", 
            3: "B", 3.33: "B+", 3.67: "A-", 4: "A"};
          if (gp[this.gradePoint] != null)
            return gp[this.gradePoint];
          else
            return '';
        }
      }
    }});

Let's put this in action, it should be no surprise that is works like this:

    attendee = new ds.Attendee({gradePoint: 3.67});
    attendee.grade;
    => "A-"

You are not limited to only get a value out of an attribute, it is completely legitimate to define what to do with a value that is assigned to a calculated attribute. And that's what `onSet` is for. So the `onSet` is just the inverse of `onGet`. You're passed a value and have to determine what to do with that. And our goal at this point is update the grade point based on the given letter grade.

    ds.Attendee.extend({attributes: {
      grade: {
        onSet: function(value) {
          var gp = {"F": 0, "D": 1, "D+": 1.33, "C-": 1.67, "C": 2, "C+": 2.33, "B-": 2.67, "B": 3, "B+": 3.33, "A-": 3.67, "A": 4};
          this.gradePoint = gp[value.toUpperCase()];
        }
      }
    }});

So again, let's try to see what happens here:

    attendee = new ds.Attendee();
    attendee.grade = "A";
    attendee.gradePoint;
    => 4

There are two more events on calculated fields, and those are `onQuery` and `onSort`. You don't need do put these on the attribute, but you are provided the opportunity to make queries a lot faster. The `onQuery` event turns the user query into query an another attribute. So instead of comparing on the grade itself, we are substituting the query with the grade point transparently.

ds.Attendee.extend({attributes: {
  grade: {
    onQuery: function(compOperator, valueToCompare) {
      valueToCompare = valueToCompare.toUpperCase();
      var gp = {"F": 0, "D": 1, "D+": 1.33, "C-": 1.67, "C": 2, "C+": 2.33, "B-": 2.67, "B": 3, "B+": 3.33, "A-": 3.67, "A": 4};
      if (gp[valueToCompare] != null)
        return 'gradePoint ' + compOperator + gp[valueToCompare];
      else
        return 'gradePoint = -1'; // force a bad result
    }
  }
}});

Let's see how this works.

    [2.33, 4, 1, 2.67, 3.67, 2].forEach(function(gp) {
      ds.Attendee.create({gradePoint: gp});
    });
    ds.Attendee.query("grade > 'C+' AND grade < 'B'");
    => [{ID: 4, gradePoint: 2.67}]

Finally, the `onSort` event is not complex at all, because it just determines the sort order. In our example it should just replace the sort order of the grade to the sort order of grade point.

    ds.Attendee.extend({attributes: {
      grade: {
        onSort: function(ascending) {
          if (ascending)
            return "gradePoint desc";
          else
            return "gradePoint";
        }
      }
    }});

So let's sort attendee entities based on `grade`

    ds.Attendee.all().orderBy("grade").grade;
    => ["A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "F"]

### Relation attributes
E.g. teacher attribute on Course of type Teacher

At this point you would typical begin to link your data classes together. So for instance, and attendee is a student who is taking a course. So we are showing how to create a relational attribute that relates to another class. We create a `student` attribute in the `Attendee` class which belongs to a student.

    ds.Attendee.extend({attributes: {
      student: {relation: "belongsTo"}
    }});

Note that the framework can infer automatically that the attribute `student` is of type `Student` simple from the way we named the attribute. Now we probably also want to add the reciprocal has many relation `attendance` onto the `Student` class.

    ds.Student.extend({attributes: {
      attendance: {relation: "hasMany", type: "Attendee"}
    }});

This time the type could not be inferred correctly, therefore, we have to add the type reference explicitly. We just extended the model that the attendee belongs to a student and a student has many attendees. So, of course, we continue adding the course into attendee.

    ds.Attendee.extend({attributes: {
      course: {relation: "belongsTo"}
    }});

We also define the reciprocal `courses` on the `Course` class.

    ds.Course.extend({attributes: {
      attendance : {relation: "hasMany", type: "Attendee"}
    }});

Let's continue on with 

    ds.Course.extend({attributes: {
      teacher: {relation: "belongsTo"}
    }});

And again, let's add the has many reciprocal relationship on `Teacher` class. However, we could also decide that we don't need that at this time. For the purpose of this book, let's add it though.

    ds.Teacher.extend({attributes: {
      courses: {relation: "hasMany"}
    }});

Elapsed 23:29

### Alias attributes
E.g. "studentName" theStudent.fullName

## Chapter 2 - Updating ##

## Chapter 3 - Mastering Find ##

## Chapter 4 - Data Modeling ##


## Chapter 5 - Performance and Tools ##

## Conslusion
