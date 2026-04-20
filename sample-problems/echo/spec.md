# Echo

## Overview

You will be building a program that echos back the text sent to it.

## Details

Your program should:
 - Read stdin line by line.
 - Remove all whitespace from the beginning and end of each line, i.e., trim the line.
 - If the trimmed string is non-empty, output the trimmed line on stdout.
   - The output string should be followed by a newline.
 - On EOF, your program should process any final line and terminate with a zero exit status.

## Clarifications

 - A "line" is a string terminated with a newline.
   - The final line of input may  be terminated by an EOF (End-of-File).
 - Only ASCII characters will be sent on stdin.
   - Treating input as ASCII or UTF-8 strings should result in the same output.
 - "Whitespace" will be considered any ASCII whitespace (see the table below).
 - A "non-empty" string is a string that contains any character and does not include any terminating null byte.

## ASCII Whitespace

| Name            | ASCII Value | C Escape Sequence |
|-----------------|-------------|-------------------|
| Horizontal Tab  |  9          | `\t`              |
| New Line        | 10          | `\n`              |
| Vertical Tab    | 11          | `\v`              |
| Form Feed       | 12          | `\f`              |
| Carriage Return | 13          | `\r`              |
| Space           | 32          |                   |
