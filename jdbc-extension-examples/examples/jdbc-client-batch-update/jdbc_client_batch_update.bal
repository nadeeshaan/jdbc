import ballerina/io;
import ballerinax/jdbc;

// Client for MySQL database. This client can be used with any jdbc
// supported database by providing the corresponding jdbc url.
jdbc:Client testDB = new({
        url: "jdbc:mysql://localhost:3306/testdb",
        username: "test",
        password: "test",
        poolOptions: { maximumPoolSize: 5 },
        dbOptions: { useSSL: false }
    });

// This is the type created to represent data row.
type Student record {
    int id;
    int age;
    string name;
};

type myBatchType int|string;

public function main() {
    // Creates a table using the update operation. If the DDL
    // statement execution is successful, the `update` operation returns 0.
    io:println("The update operation - Creating a table:");
    var ret = testDB->update("CREATE TABLE student(id INT AUTO_INCREMENT,
                         age INT, name VARCHAR(255), PRIMARY KEY (id))");
    handleUpdate(ret, "Create student table");

    json jsonMsg = {
        "student": [{
            "firstname": "Peter",
            "age": 10
        }, {
            "firstname": "John",
            "age": 15
        }, {
            "firstname": "James",
            "age": 12
        }]
    };

    // Prepare the data batches.
    int datalen = jsonMsg.student.length();
    myBatchType[][] dataBatch = [];
    int i = 0;

    json[] students = <json[]>jsonMsg.student;
    foreach (var studentData in students) {
        string name = studentData.firstname.toString();
        int age = <int>studentData.age;

        myBatchType[] dataRow = [age, name];
        dataBatch[i] = dataRow;
        i = i + 1;
    }
    // A batch of data can be inserted using the `batchUpdate` operation. The number
    // of inserted rows for each insert in the batch is returned as an array.
    var retBatch = testDB->batchUpdate("INSERT INTO student
                    (age,name) VALUES (?,?)", ...dataBatch);
    if (retBatch is int[]) {
        io:println("Batch 1 update counts: " + retBatch[0]);
        io:println("Batch 2 update counts: " + retBatch[1]);
    } else if (retBatch is error) {
        io:println("Batch update operation failed: " + <string>retBatch.detail().message);
    }

    //Check the data in the database.
    checkData();

    io:println("\nThe update operation - Drop the student table");
    ret = testDB->update("DROP TABLE student");
    handleUpdate(ret, "Drop table student");
}

// Function to handle return of the update operation.
function handleUpdate(int|error returned, string message) {
    if (returned is int) {
        io:println(message + " status: " + returned);
    } else if (returned is error) {
        io:println(message + " failed: " + <string>returned.detail().message);
    }
}

// Select data from the table and print.
function checkData() {
    var dtReturned = testDB->select("SELECT * FROM student", Student);

    if (dtReturned is table<Student>) {
        // Iterating data.
        io:println("Data in students table:");
        foreach var row in dtReturned {
            io:println("Student:" + row.id + "|" + row.name + "|" + row.age);
        }
    } else if (dtReturned is error) {
        io:println("Select data from student table failed: "
                + <string>dtReturned.detail().message);
    }
}
