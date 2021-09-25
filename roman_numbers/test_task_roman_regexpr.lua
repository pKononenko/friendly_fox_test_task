-- Roman Test Task using regular expressions


function ternary (cond, true_, false_)
    if cond then return true_ else return false_ end
end

-- Optimize Roman Number
-- using gsub regexpr
function roman_optimize(roman)
    -- We do not use simple dictionary-style table
    -- to save table order when we iterate using ipairs
    roman_pairs = {
      {'VIIII', 'IX'},
      {'IIII', 'IV'},
      {'LXXXX', 'XL'},
      {'XXXX', 'XC'},
      {'DCCCC', 'CM'},
      {'CCCC', 'CD'}
    }
    
    -- We use ipairs because order of
    -- transformations matter
    for int_k, v_arr in ipairs(roman_pairs) do
        roman = roman:gsub(v_arr[1], v_arr[2])
    end
    
    return roman
end


changes_count = 0
filename = "roman.txt"
output_filename = "roman_out_regexr.txt"

-- Open file
f = io.open(filename, "r")

-- Open output file
f_output = io.open(output_filename, "w")

-- Iterate over file
for line in f:lines() do
    local new_roman = roman_optimize(line)
    local len_diff = #line - #new_roman
    
    -- if we apply such transformation
    -- string len decrease
    changes_count = changes_count + len_diff
    f_output:write(string.format("%-16s %-16s %s", line, new_roman, ternary(len_diff > 0, "changed" ,"")), "\n")
end

print(string.format("Number of changed symbols: %s", changes_count))

-- Close file
f:close()

-- CLose output file
f_output:close()

