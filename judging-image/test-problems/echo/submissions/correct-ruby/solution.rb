def main()
    $stdin.each_line do |line|
        line = line.strip()
        if (line.length == 0) then
            next
        end

        puts line
    end
end

if ($PROGRAM_NAME == __FILE__) then
    main()
end
