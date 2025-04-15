# sh

## how to do redirect
```
user@user-mac test % ls
data.json	link.sh		salary.txt
fakePass.txt	names.txt	test.sh

// > redirect a file but does not append
user@user-mac test % ls -l . > output.txt
user@user-mac test % ls
data.json	link.sh		output.txt	test.sh
fakePass.txt	names.txt	salary.txt
user@user-mac test % vim output.txt

user@user-mac test % > output.txt

user@user-mac test % ls
data.json	link.sh		output.txt	test.sh
fakePass.txt	names.txt	salary.txt
user@user-mac test % > ./output.txt 

//>> redirect to a file but append
user@user-mac test % ls -l . >> output.txt 
user@user-mac test % ls
data.json	link.sh		output.txt	test.sh
fakePass.txt	names.txt	salary.txt
user@user-mac test % less output.txt 
user@user-mac test % ls -l . >> output.txt
user@user-mac test % less output.txt 
user@user-mac test % 
user@user-mac test % ls ./fake 
ls: ./fake: No such file or directory
user@user-mac test % ls ./fake > error.txt
ls: ./fake: No such file or directory

//2> redirect standerror to a file
user@user-mac test % ls ./fake 2> error.txt
user@user-mac test % ls
data.json	fakePass.txt	names.txt	salary.txt
error.txt	link.sh		output.txt	test.sh
user@user-mac test % less error.txt 
user@user-mac test %

//2>&1 redirect both output and error to both.txt file
user@user-mac test % ls ./fake > both.txt 2>&1
user@user-mac test % ls
both.txt	error.txt	link.sh		output.txt	test.sh
data.json	fakePass.txt	names.txt	salary.txt
user@user-mac test % less both.txt 
user@user-mac test %

// &> redirect both output and error to both.txt file 
user@user-mac test % ls ./fake &> both.txt   
user@user-mac test % less both.txt

// &>> redirect and append both output and error to both.txt file 
user@user-mac test % ls ./fake &>> both.txt

user@user-mac test % less both.txt 
user@user-mac test %

//&> /dev/null, discard all info, blackhole
user@user-mac test % ls ./fake &> /dev/null
```

## 🧾 To replace one word with another **in the whole file**:

```vim
:%s/oldword/newword/g
```

### 🔍 What it means:
- `:` → enter command mode
- `%` → apply to the **whole file**
- `s` → **substitute**
- `/oldword/` → the word to search
- `/newword/` → the word to replace with
- `g` → replace **all occurrences** in each line (not just the first)

---

## ✅ Example:

You have:
```txt
hello world
hello there
```

You run:
```vim
:%s/hello/hi/g
```

You get:
```txt
hi world
hi there
```

---

## 🗂 Replace in current **line only**:
```vim
:s/oldword/newword/g
```

---

## 🔎 Ask before each replacement:
Add a `c` (confirm):
```vim
:%s/oldword/newword/gc
```
You’ll get a `[y/n/a/q/l]` prompt:
- `y` → yes
- `n` → no
- `a` → all
- `q` → quit
- `l` → last

---

## 🔹 What does `2>/dev/null` do?

This part of a command:
```bash
2>/dev/null
```

Means:

> “Redirect **stderr (file descriptor 2)** to **`/dev/null`**, which discards it completely.”

---

## 🧠 In detail:

### ✅ File descriptors in Unix:
- `0` → stdin (input)
- `1` → stdout (normal output)
- `2` → stderr (error output)

So when you write:
```bash
some_command 2>/dev/null
```

You’re saying:
> “Run `some_command`, but **suppress any error messages** it tries to print.”

---

## 🗑️ What is `/dev/null`?
- It’s a **special file** that discards anything you write to it.
- It's like a **black hole** for output — useful when you want to ignore something completely.

---

## 🔍 Example:

```bash
jq . invalid.json
```

If `invalid.json` has bad JSON, you get:
```
parse error: Expected value at line 1, column 1
```

But with:
```bash
jq . invalid.json 2>/dev/null
```

You get **no output**, no error — just silence.

---

## 🔧 Why use this?

- To **suppress error messages** in scripts and avoid cluttering the terminal.
- To **check if something succeeds quietly**, without logging the error unless you want to.

---

## 🔄 Also useful:

- Redirect both stdout and stderr:
  ```bash
  some_command > /dev/null 2>&1
  ```

This means:
> Send stdout to `/dev/null`, and send stderr **to wherever stdout is now going** (also `/dev/null`).


## 🧠 What is `jq`?

- **`jq`** is a **command-line tool** for **parsing, filtering, transforming, and formatting JSON** data.
- It’s like `awk` or `sed`, but for **structured JSON**.
- It's super useful when you're dealing with API responses, config files, cloud CLIs (like `oci`, `aws`, `az`), or anything that spits out JSON.

---

## 🧰 What is `jq` used for?

### 🔹 1. **Pretty-print JSON**
```bash
jq . data.json
```
Neatly formats raw JSON.

---

### 🔹 2. **Extract specific values**
```bash
jq '.name' data.json
```
Gets the value of the `name` field.

Example:
```json
{ "name": "Alice", "age": 30 }
```

Output:
```
"Alice"
```

---

### 🔹 3. **Chaining nested fields**
```bash
jq '.user.name.first' data.json
```

---

### 🔹 4. **Filter items in arrays**
```bash
jq '.users[] | select(.active == true)' data.json
```
Gives you only users with `"active": true`.

---

### 🔹 5. **Map and transform data**
```bash
jq '.users[] | {name: .name, email: .email}' data.json
```
Creates a simplified view of the users.

---

### 🔹 6. **Combine with other shell tools**
```bash
curl https://api.example.com/data | jq '.results[0].title'
```

---

### 🔹 7. **Compact output (no pretty formatting)**
```bash
jq -c '.users[]' data.json
```



## 🧠 What is `awk`? - AWK is to select 1 column and then filter by what
- `awk` is a **pattern scanning and processing language**.
- It reads **input line by line**, splits lines into **fields**, and lets you apply **rules** to each line or field.
- Named after its creators: **A**ho, **W**einberger, and **K**ernighan.

---

## 🧰 What is `awk` used for?

Here are **common use cases**:

### 1. **Extracting specific columns**
```bash
awk '{print $1}' file.txt
```
Prints the **first column** of each line (by default, fields are split by spaces).

Example:
```bash
cat names.txt
John Smith
Alice Tan
```

```bash
awk '{print $2}' names.txt
# Output:
Smith
Tan
```

---

### 2. **Using custom field separators**
```bash
awk -F: '{print $1}' /etc/passwd
```
`-F:` tells `awk` to use `:` as the **field delimiter**.

---

### 3. **Filtering lines**
```bash
awk '$3 > 100' data.txt
```
Only print lines where the **third column** is greater than 100.

---

### 4. **Summing numbers**
```bash
awk '{sum += $2} END {print sum}' salaries.txt
```
Adds up the **second column** of all lines.

---

### 5. **Formatting output**
```bash
awk '{printf "Name: %s, Score: %d\n", $1, $2}' scores.txt
```
Formats output like a mini reporting tool.

---

### 6. **Field calculations**
```bash
awk '{print $1, $2, $3 * 2}' data.txt
```
Maybe your 3rd column is quantity — this prints it **doubled**.

---

### 🔁 Structure of an `awk` command:
```bash
awk 'pattern { action }' filename
```
- `pattern` — when to apply the rule (can be empty = always)
- `action` — what to do (e.g. print, sum, etc.)

---

### 🔂 Example with pattern:
```bash
awk '$1 == "ERROR" {print $0}' logfile.txt
```
Print only lines where the **first word is "ERROR"**.

---

## 🔧 Why use `awk`?
- It’s more powerful than `cut` or `grep` when you need **logic or calculations**.
- Lightweight compared to writing a full Python script.
- Common in sysadmin scripts, log parsing, and quick CLI data tasks.

---



## 👪 What is a **parent shell**?

The **parent shell** is your **main shell session** — the one you start when you open your terminal. This shell:

- Lets you run commands
- Holds your environment variables
- Can define functions, aliases, etc.

This is your "main room" where you’re doing all your work.

---

### 🐣 What is a **subshell**?

A **subshell** is like a **child process** of your main shell — it’s a new instance of the shell, started from inside the current one.

It has its **own environment**, separate from the parent shell.

You can think of it like this:

```
Main shell (parent)
│
├── Subshell (child)
│     ├── Can run commands
│     ├── Can have its own variables
│     └── Will exit when done
```

---

### 🔄 Example: variable in parent vs. subshell

```bash
# In parent shell
myvar="hello"
(echo "In subshell: $myvar")  # works: subshell inherits variables

(myvar="changed in subshell")
echo "Back in parent: $myvar"  # still "hello" – change didn't leak back!
```

- Subshell **inherits** variables from the parent.
- But any changes in the subshell **do not affect** the parent.

---

### 🚨 Why does this matter?

When writing shell scripts or functions, if you want something to persist **outside** a subshell (like a variable or function), you have to be aware that subshells don’t pass things back to the parent.

Let me know if you want visual examples or something interactive to try!

Sure! `awk` is a powerful text-processing tool used in **Unix-like** operating systems for pattern scanning and processing. It is typically used for tasks like extracting, manipulating, and reporting data from text files or input streams.

### **What is `awk`?**
`awk` is a **pattern scanning** and **processing language**. It processes text line by line, splits each line into fields, and performs actions on those fields based on patterns that match.

---

### **Basic Syntax:**
```sh
awk 'pattern { action }' file
```

- **`pattern`**: A condition that `awk` checks for each line. If the pattern matches, the action is executed.
- **`action`**: The operation that `awk` performs when a line matches the pattern.
- **`file`**: The file to process. If no file is given, `awk` reads from standard input (e.g., a pipeline).

If no **pattern** is given, `awk` performs the **action** on every line. If no **action** is given, `awk` prints the line by default.

---

### **How `awk` Works:**
1. **Reads input** (line by line).
2. **Splits each line** into **fields** (by default, fields are separated by whitespace).
3. **Matches patterns** in each line.
4. **Performs actions** when a pattern matches.

---

### **Basic Example:**

```sh
echo "Hello World" | awk '{ print $1 }'
```
This command outputs:
```
Hello
```

Explanation:
- `awk '{ print $1 }'`: The **action** `print $1` tells `awk` to print the **first field** (`$1`) of the input.
- Fields are split by **whitespace** by default, so `Hello` is printed because it is the first word in the line.

---

### **Key Concepts in `awk`:**

1. **Fields in `awk`:**
   - `awk` divides each input line into **fields**, which can be referenced by `$1`, `$2`, `$3`, etc.
   - `$0` refers to the **entire line**.
   - By default, fields are separated by **whitespace** (spaces or tabs).

   **Example:**
   ```sh
   echo "John 25 Developer" | awk '{ print $1, $2 }'
   ```
   Output:
   ```
   John 25
   ```
   Here, `$1` refers to `John`, and `$2` refers to `25`.

2. **Pattern Matching:**
   - Patterns can be strings or regular expressions.
   - If the pattern matches the input, the **action** is executed.

   **Example:**
   ```sh
   echo "John 25 Developer" | awk '$2 == 25 { print $1 }'
   ```
   Output:
   ```
   John
   ```
   Here, the pattern `$2 == 25` matches when the **second field** is `25`, and the action prints the **first field**.

3. **Built-in Variables in `awk`:**
   - `NR`: The **number of records** (lines) processed so far.
   - `NF`: The **number of fields** in the current record (line).
   - `$0`: The entire current line.
   - `$1`, `$2`, ...: Individual fields in the current record.

   **Example:**
   ```sh
   echo -e "John 25 Developer\nJane 30 Manager" | awk '{ print NR, $1, $2 }'
   ```
   Output:
   ```
   1 John 25
   2 Jane 30
   ```
   Here, `NR` is the line number, `$1` is the first field (name), and `$2` is the second field (age).

4. **Operators in `awk`:**
   - You can use various operators for comparisons or arithmetic:
     - Comparison: `==`, `!=`, `<`, `>`, `<=`, `>=`
     - Arithmetic: `+`, `-`, `*`, `/`, `%`

   **Example:**
   ```sh
   echo -e "John 25\nJane 30" | awk '$2 > 25 { print $1 }'
   ```
   Output:
   ```
   Jane
   ```

5. **Actions:**
   - Actions in `awk` are enclosed in curly braces `{}`.
   - The default action is to **print** the matching line (`print $0`), but you can specify custom actions like printing specific fields, performing calculations, or modifying data.

---


## declare array in shell
In shell scripting (specifically in **Bash**), arrays can be declared and used in the following ways:

---

### **1. Declaring an Array**
To declare an array in Bash, you simply use the following syntax:

```sh
array_name=(value1 value2 value3 ...)
```

### **Example:**
```sh
fruits=("apple" "banana" "cherry")
```

- This creates an array called `fruits` with 3 elements: `"apple"`, `"banana"`, and `"cherry"`.

---

### **2. Accessing Array Elements**
You can access individual elements in an array using the index (starting from 0):

```sh
echo ${fruits[0]}  # Outputs: apple
echo ${fruits[1]}  # Outputs: banana
```

---

### **3. Getting All Elements**
To get all elements in the array:
```sh
echo ${fruits[@]}  # Outputs: apple banana cherry
```

- `[@]` or `[*]` will expand to all elements in the array.

---

### **4. Getting the Length of an Array**
To get the number of elements in an array:
```sh
echo ${#fruits[@]}  # Outputs: 3
```

---

### **5. Adding an Element to an Array**
To add an element to an array:
```sh
fruits+=("orange")  # Adds 'orange' to the end of the array
```

---

### **6. Modifying an Element**
To change a specific element:
```sh
fruits[1]="blueberry"  # Changes 'banana' to 'blueberry'
```

---

### **7. Looping Through an Array**
You can loop through an array using a `for` loop:

```sh
for fruit in "${fruits[@]}"; do
  echo $fruit
done
```

This will output:
```
apple
banana
cherry
```

---

### **8. Declaring an Indexed Array (Alternative)**
Bash also supports **indexed arrays**, which can be declared element-by-element:

```sh
fruits[0]="apple"
fruits[1]="banana"
fruits[2]="cherry"
```

---

### **9. Declaring Associative Arrays (Bash 4.0+ Only)**
If you're using **Bash 4.0** or later, you can declare **associative arrays** (key-value pairs):

```sh
declare -A fruits
fruits["apple"]="green"
fruits["banana"]="yellow"
fruits["cherry"]="red"
```

Accessing elements:
```sh
echo ${fruits["apple"]}  # Outputs: green
```

### **Summary**
- **Normal array:** `array=(value1 value2 ...)`
- **Access elements:** `${array[index]}`
- **All elements:** `${array[@]}`
- **Length of array:** `${#array[@]}`
- **Add to array:** `array+=("new_value")`

---

Let me know if you want further examples or need more details! 😊

Yes, a `.log` file is typically a **text file** used to store **log data** or **event information** generated by a program or system.

### **What Is a `.log` File?**
- `.log` files store information about the **execution** of a program, system events, or application activities.
- These files are often used for **debugging**, **monitoring**, and **troubleshooting**.

### **Typical Contents of a `.log` File**
A `.log` file may contain entries like:
- **Timestamps** of when events occurred.
- **Messages** generated by the application (e.g., "Download complete", "Error: File not found").
- **Error codes** or **warnings** generated during execution.
- **Status information** (e.g., "Process started", "Process finished").

### **Example of a `.log` File:**
```text
2025-04-03 15:30:45 - Starting Java download...
2025-04-03 15:31:00 - Downloading file from URL: http://example.com/java
2025-04-03 15:31:15 - Download complete.
2025-04-03 15:31:20 - Saving file to /path/to/java_installation.zip
2025-04-03 15:31:30 - Installation successful.
```

---

### **Why Use `.log` Files?**
1. **Track Application Behavior:**  
   Logs are useful to track how a program is behaving over time (e.g., are there repeated errors?).

2. **Debugging & Troubleshooting:**  
   If an error occurs, logs can help identify what happened before the issue.

3. **Audit & Record Keeping:**  
   Logs help keep records of activities, useful for audits or understanding system usage.




## What are `stdout` and `stderr`?

In computing, `stdout` and `stderr` are two distinct **streams** that handle output in a program, allowing separation of normal output and error messages.

- **`stdout` (Standard Output)**: This is the default stream used by most programs to send their regular, non-error output. For instance, when you run a command like `ls`, it will list files and directories to `stdout`.
  
- **`stderr` (Standard Error)**: This is a separate stream used specifically for error messages. It allows error messages to be distinct from normal output. For example, if a command encounters an error (like a missing file), it will send the error message to `stderr`.

Both streams are part of the **three standard streams** that a process typically uses in Unix-like operating systems, the third being **`stdin` (Standard Input)**, which is used for receiving input from users or other programs.

### Why Do We Need `stdout` and `stderr`?

1. **Separation of Concerns**:
   - By keeping **normal output** and **error messages** in separate streams, it becomes easier to distinguish between them. This separation helps in debugging, logging, and processing outputs in a more organized way.
   - **Normal output** (`stdout`) can be processed by downstream programs or saved to a file, while **error messages** (`stderr`) can be sent to the user or logged separately for troubleshooting.

2. **Redirection and Piping**:
   - In command-line environments (like Unix or Linux), you can **redirect** both `stdout` and `stderr` separately.
   - For example, you can direct the normal output of a command to a file but send error messages to the console (or a different file). Here's how redirection works:
     - Redirect **stdout** to a file:
       ```sh
       some_command > output.txt
       ```
     - Redirect **stderr** to a file:
       ```sh
       some_command 2> error.txt
       ```

3. **Better Error Handling**:
   - If errors were mixed with normal output, it would be harder to distinguish between the two. For instance, if an error occurs while processing data, mixing it in with valid data would make the output unreadable.
   - By using **stderr**, you can catch errors separately and handle them differently (e.g., alert the user, log to a different file, or trigger automatic error handling).

4. **Enhanced Script and Program Debugging**:
   - When running scripts or programs, developers can more easily debug issues by checking **stderr** for error messages while still capturing **stdout** for valid data.
   - For example, when testing scripts, you can ensure that any error message from a failed operation is logged or displayed separately from the program's expected output.

5. **Streamlining Automated Processes**:
   - Automated systems (like cron jobs, monitoring scripts, or CI/CD pipelines) can process **stdout** and **stderr** separately, allowing better handling of success and failure cases.
   - **stdout** might be stored in logs or used in further processing, while **stderr** might trigger notifications or alert system administrators if errors are encountered.

### A Simple Example:

Consider a script that processes some files. If an error occurs, you want to log it separately from the output. For example:

```sh
#!/bin/bash

echo "Processing files..."

# Normal output goes to stdout
echo "File 1 processed successfully."

# Simulate an error: redirects error to stderr
echo "Error: File 2 not found." >&2

echo "Processing completed."
```

Output:
```
File 1 processed successfully.
Error: File 2 not found.  (This would be printed to stderr)
Processing completed.
```

Here, the regular output (like `"File 1 processed successfully."`) goes to **stdout**, and the error message (`"Error: File 2 not found."`) goes to **stderr**.

### In Summary:

- **`stdout`**: Handles normal output—information the program wants to convey, like results or status messages.
- **`stderr`**: Handles error output—messages indicating problems or issues that occurred during execution.

By separating these streams, programs become more flexible and easier to manage, especially in environments where large amounts of data or error-prone operations are being handled.

## concatenate strings
```
# basic string concatenate $varName
str1="Hello, "
str2="World!"
greeting="$str1$str2"
echo $greeting

# use curly braces to make var look cleared
username="alice"
echo "Welcome, ${username}!"

# concatenate file path
file_prefix="photo"
file_suffice=".jpg"
file_name="${file_prefix}_$(date +%y%m%d)${file_suffix}"
echo "file name is ${file_name}"

# put command in () to be executed then capture as var
dateFormat=$(date)
echo "dateFormat is ${dateFormat}"
# dateFormat is Thu Apr  3 15:23:54 +08 2025


#conca full path
dir="/var/log"
filename="$(date +%y%m%d)_report.log"
full_path="${dir}/${filename}"
echo "full path is ${full_path}"
```
