# Hints

This document gives some general hints for contestants.

## Reading All Lines from stdin

A common necessity in QFCC events is the need to read a line from [stdin](https://en.wikipedia.org/wiki/Standard_streams#Standard_input_(stdin)).
Although the task is simple,
it may not be a common one for most developers.
Here, we will show one possible way to do this in each supported language.
These hints are not comprehensive (there may be many ways to accomplish this),
not complete (details on every part of the code snippet will not be provided).

### C

```c
#include <stdio.h>

char buffer[1024];
char* result = NULL;

while (1) {
    result = fgets(buffer, 1024, stdin);
    if (result == NULL) {
        break;
    }
}
```

### C++

```c++
#include <iostream>
#include <string>

for (std::string line; std::getline(std::cin, line); ) {
}
```

### Java

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
while (true) {
    String line = null;
    try {
        line = reader.readLine();
    } catch (IOException ex) {
        break;
    }

    if (line == null) {
        break;
    }
}
```

### Python

```python
import sys

for line in sys.stdin:
    pass
```

### Ruby

```ruby
$stdin.each_line do |line|
end
```
