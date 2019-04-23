-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
-- file:   spigot.adb
-- goal:   allows user to enter an output file name, then calculates pi
--         using the spigot algorithm and outputs the result to the file.
-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

-- **************************************************************
-- procedure: spigot
-- goal:      calculate pi and write result to user defined file
-- **************************************************************
procedure spigot is
    -- declare and initialize variables
    i, k, q, x, o, nines, predigit, size: integer := 0;
    j : integer := 1;
    precision : constant := 1000;
    arr: array (0 .. 3334) of integer;
    filename : string (1 .. 200);
    last : natural;

    -- declare output file
    outfp : file_type;

begin
    new_line;
    put_line("---------------------------------------");
    put_line("   WELCOME TO MY SPIGOT ALGORITHM!");
    put_line("         (Ada edition)");
    put_line("    Built with love for CIS*3190");
    put_line("    By: Maddie Gabriel (0927580)");
    put_line("---------------------------------------");
    new_line;

    -- otain user input for filename
    put("Enter output filename (include extension): ");
    get_line(filename, last);
    new_line;
    create(outfp, out_file, filename);

    put("*** Please wait while your result is calculating! ***");
    new_line;
    new_line;

    -- calculate array length
    size := (10 * precision / 3) + 1;

    -- initialize array to all 2's
    loop
        arr(o) := 2;
        o := o + 1;
        exit when o = 3333;
    end loop;

    -- until I specify otherwise, all 'put' output will go to the file
    set_output(outfp);

    -- repeat calculation loop 'precision' times - depends on desired precision
    loop
        q := 0;

        -- calculate q
        i := size;
        loop
            x := 10 * arr(i-1) + q*i;
            arr(i-1) := x mod (2 * i-1);
            q := x / (2 * i-1);
            i := i - 1;
            exit when i = 0;
        end loop;

        arr(0) := q mod 10;
        q := q / 10;

        -- append different digits based on q value
        if q = 9 then
            -- if q is 9, increment nines counter
            nines := nines + 1;
        elsif q = 10 then
            -- if q is 10 (overflow case), write 9 then predigit + 1
            put(predigit + 1, Width => 0);
            k := 0;
            while k < nines loop
                put(0, Width => 0);
                k := k + 1;
            end loop;
            predigit := 0;
            nines := 0;
        else
            -- if q is not 9 or 10, print predigit
            put(predigit, Width => 0);

            -- advance predigit to next q
            predigit := q;

            -- handle nines which were tracked
            if nines /= 0 then
                k := 0;
                loop
                    put(9, Width => 0);
                    k := k + 1;
                    exit when k = nines;
                end loop;
                nines := 0;
            end if;
        end if;

        j := j + 1;
        exit when j = precision;
    end loop;

    -- add the final digit
    put(predigit, Width => 0);
    put(989, Width => 0);
    
    -- close output file and change back to std output
    set_output(standard_output);
    close(outfp);

    -- tell user where to see their result
    put_line("Please see your results in this file: " & filename);
    new_line;

end spigot;
