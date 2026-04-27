const readline = require('readline');

const reader = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
});

reader.on('line', function(line) {
    line = line.trim();
    if (line.length == 0) {
        return;
    }

    console.log(line);
});
