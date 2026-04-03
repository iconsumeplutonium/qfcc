import sys

def main():
    for line in sys.stdin:
        line = line.strip()
        if (len(line) == 0):
            continue

        print(line)

if (__name__ == '__main__'):
    main()
