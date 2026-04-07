#include <cctype>
#include <iostream>
#include <string>

std::string strip(std::string text) {
    // Left Strip
    int start = 0;
    for (int i = 0; i < text.size(); i++) {
        if (!std::isspace(text[i])) {
            break;
        }

        start++;
    }

    // Right Strip
    int end = text.size();
    for (int i = 0; i < text.size(); i++) {
        if (!std::isspace(text[text.size() - 1 - i])) {
            break;
        }

        end--;
    }

    // Empty String
    if (start >= end) {
        return "";
    }

    std::string result = "";
    for (int i = 0; i < (end - start); i++) {
        result += text[start + i];
    }

    return result;
}

int main() {
    for (std::string line; std::getline(std::cin, line); ) {
        line = strip(line);
        if (line.size() != 0) {
            std::cout << line << std::endl;
        }
    }

    return 0;
}
