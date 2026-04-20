# Development

## Adding Language Support

When adding support for a new language, make sure to check the following things:
 - Add compiler/interpreter in the judging image.
   - Note the language, version, and extension in the [contest image documentation](../contest-image/README.md#language-support).
 - Update the [judging script](./scripts/judge-submission.sh).
 - Add a test submission in the [echo sample problem](./sample-problems/echo).
 - Update the competition image.
   - Ensure that no compiler/interpreter is installed on the system.
   - Ensure that no source files exist in the image.
     - For example, to look for C files we could do: `find / -type f -name '*.c'`.
 - Add any required [hints](../contest-image/HINTS.md).
