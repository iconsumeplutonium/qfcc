# Quality First Coding Competition

A programming competition with a twist!

Traditional programming contests focus on developing accurate solutions quickly.
The Quality First Coding Competition (QFCC) focuses on developing accurate solutions **well**.
Of course, measuring the "quality" of a piece of code is impossible and subjective,
so this contest uses number of compiles/runs as a proxy for quality.

Today, more than ever, it is important for developers to be able to recognize, develop, and appreciate high-quality code.
Even code produced by AI must be reviewed and revised for quality.
This contest is meant to emphasize some of the qualities it takes to be a great software developer in practice.

This iteration of the this contest was inspired by
[Dr. John Dalbey's "Quality First Programming Contest"](https://users.csc.calpoly.edu/~jdalbey/Contest/).
Which was, in-turn, influenced by
Dr. James Bowring's [A New Paradigm for Programming Competitions](https://dl.acm.org/doi/abs/10.1145/1352322.1352166).

The information in this document applies to this variation of the contest.
Specific events may vary their rules.

**Quick Links:**
 - [Contest Overview](#contest-overview)
   - [Practice Problems](#practice-problems)
 - [Contest Procedure](#contest-procedure)
 - [Available Text Editors](contest-image/README.md#text-editors)
 - [Language Support](contest-image/README.md#language-support)
 - [Hints for Contestants](contest-image/HINTS.md)
 - [Developer Notes](./development.md)

## Repository

This repository provides instructions, tools, and materials for running a QFCC.
All material is licensed under the [MIT License](LICENSE).
This license does not extend to graphical artifacts (e.g., images) in this repository.

## Contest Overview

In this contest, contestants must create a program to solve a given problem specification.
Contestants are ranked first by the number of attempts they take to produce a correct solution,
and then by how long it took to produce that solution.

This competition differs from more traditional competitions in the following ways:

 - **Problem Difficulty is Reduced** --
     The problem contestants must solve is considerably easier than traditional programming contests.
     We plan for anyone with roughly one year of programming experience/knowledge to be able to compete without issue.
     Knowledge of common data structures is useful, but not necessary.
 - **Accuracy is Emphasized over Speed** --
     In traditional programming contests, speed is the most important factor.
     Here, speed is only used to break ties.
 - **Execution Time is Ignored** --
     Many programming contests either rank solutions based on execution time or set a maximum execution time.
     In this contest, execution time is not considered.
 - **Better Feedback** --
     In this contest you will get a full copy of your output, instead of just information on whether or not it passed.

### Practice Problems

You can always practice "quality first" programming anytime you program.
Just focus on the correctness of your code, see if you can use your memory over your autocomplete, and carefully consider your compilation/runtime errors.

If you want to practice problems that are more specific to this contest,
we have at least one sample problem in the [sample-problems](./sample-problems) directory.
Each problem should have a `spec.md`, which would be given to a contestant in a real competition.
You can also use the scripts from the judging directory to check your submission
(see [judging-image/README.md](./judging-image/README.md)).

For example, to test the `echo` sample problem, you may do:
 - Read [the problem specification](./sample-problems/echo/spec.md).
 - Make a `practice` directory: `mkdir practice`.
 - Create a submission in `practice/solution.c` (or whatever language you want to use).
 - Check your submission with: `./judging-image/scripts/run-docker-judge.sh practice sample-problems/echo/oracle`

## Contest Procedure

Below is the general outline for how a contestant takes part in a competition.

1 -- Arrive and Check-In

   - Contestants are individually timed, so do not worry if it takes some time to get started.
     - Leave your email address so you can be contacted if you win and have to leave early.
   - Contestants can generally arrive up to one hour after the contest starts and still compete.

2 -- Check-In Phone

   - You can optionally check-in your phone.
     - Be sure to put your phone on silent.
   - We recommend checking-in your phone, as even touching your phone during competition can be grounds for disqualification.

3 -- Give Laptop to Judges to Prepare

   - Judges will load the [contest image/OS](#contest-image) onto your laptop.
     - No storage will be used/modified/deleted in this process (your files are safe).
     - Rebooting the laptop will return it to normal.

4 -- Receive Problem Specification

   - Once you have your configured laptop and seat, judges will hand you:
     - a problem specification,
     - a piece of scratch paper,
     - and a USB stick to use to transfer solutions.
   - Time starts when you get the problem specification.
   - You may request additional scratch paper at any time.

5 -- Work on Your Solution
   - We recommend starting on paper before typing your solution.
   - You may ask [clarification questions](#asking-for-clarification).
   - You may take [bathroom breaks](#bathroom-breaks).

6 -- Submit Solution

   - Once you think you have a working solution, copy your solution to the provided USB stick and place it in the judging queue.
     - Your file should be named [according to the language you are using](#language-support).
     - Your submission file should be the ONLY THING on the USB drive.
   - You may submit as many times as you want.

7 -- Await Judging

   - If you have a correct solution:
     - Then, judges will record your success and current rank on the board.
       - Continue to step 8.
     - Else, judges will copy the output of your run onto the same USB stick and place it in the output queue.
       - Retrieve your USB and go to step 5.
       - If you solution takes too long to run, a judge may kill it early.

8 -- Wait for Final Rankings

   - Once your score is recorded, you can leave the contest room.
     - Hopefully there will be food waiting for your in the designated waiting area.
   - When final ranks are decided, the judges will let everyone know.
     - You will be emailed if you win and have to leave early.

### Phone Check-In

Phones are not allowed during the competition.
Using a phone may be subject to immediate disqualification.
(You are not required to check-in your phone, but just touching your phone may be grounds for disqualification.)

Before you are given the problem,
you may give your phone to a judge.
The judge will give you a slip so that you can retrieve your phone at the end of the event.

We recommend that you put your phone on silent
(so the judges don't have to fumble with it during the competition).
If available, isolation bags may be used.

### Asking for Clarification

If you have a clarification question, you may submit it in writing to the judges.
If this is a question that the judges can answer,
the judges will write the answer on the board for all to see.

### Bathroom Breaks

Bathroom breaks are typically allowed under the following conditions:
 - No provided materials (e.g., paper, USB sticks) can be taken to the bathroom.
 - Your phone must remain checked-in while you are in the bathroom.
   - If you have not checked-in your phone, then you must do so at this time.
   - If you do not have a phone, you must attest to the judges that you do not have a phone with you.
 - Judges may limit the number of contestants in the bathroom at a time.

### Ground for Disqualification

Below is a non-exclusive list of things you can be disqualified for:

 - Rude or Disrespectful Behavior
 - Use of Compilers
 - Use or Predictive Features
   - This includes things like autocomplete (based on language syntax) or AI/LLMs.
 - Use of Phone
   - We recommend checking-in your phone and setting it to silent.
 - Use of Internet
 - Collaboration with Anyone Else
 - Using a Non-Approved USB Drive
 - Rebooting Your Machine
   - This will cause your machine to go back to normal.
   - If this accidentally happens, immediately leave your machine and ask a judge for help.
 - Submitting Malicious Submission
   - This includes submissions that are malicious,
     attempts to bypass the intended problem,
     or attempts to discover details about the code used to evaluate submissions.
 - Violating the Spirit of the Contest
   - This includes things like using a tool or documentation accidentally left on the machine.
     - Discretion is given to the judges on whether or not you violated the spirit of the contest,
       but there is not really a valid reason for exploring the filesystem mid-contest.

### Withdrawing

You are free to withdraw at any time.
Just let the judges know and leave the room.

### Resources

Things to bring:
 - Yourself
 - Laptop with USB Ports
   - If you don't have one, the event hosts may be able to supply one (but supplies will likely be limited).
 - Pen/Pencil

Things that will be provided:
 - USB with Bootable Linux Image
 - USB to transfer Solutions
 - Paper
 - Food

## Contest Image

To ensure an even playing field, all contestants will use the same [Operating System image](https://en.wikipedia.org/wiki/System_image).
This image contains a basic UNIX environment, text editors, and a simple GUI.
However, it is meant to not contain anything that may give a contestant or language an advantage,
such as compilers, predictive autocomplete, documentation, or internet access.

The code to build the image lives in this repository under the [contest-image directory](./contest-image).
We appreciate PRs that add editor or language support.

### Text Editors

Text editors are the recommended way to write down your code.
Because of the nature of the contest (no compiling or predictive features),
IDEs are generally disallowed.
Note that only editors with autocomplete based on knowledge of a language's syntax are disallowed.
Editors that autocomplete based on the tokens in the current file/directory are allowed.

The available text editors are listed in the
[contest image information](contest-image/README.md#text-editors).

If you are new to text editors (e.g., you have only used IDEs),
then we recommend a simple GUI-based one like Mousepad.

### Language Support

All submissions should be contained in a single file with the `solution` basename.
The supported languages as well as their extensions are listed in the
[contest image information](contest-image/README.md#language-support).

## Acknowledgements

A special thanks to [Dr. John Dalbey](https://users.csc.calpoly.edu/~jdalbey) for providing the inspiration and initial materials for this event.
