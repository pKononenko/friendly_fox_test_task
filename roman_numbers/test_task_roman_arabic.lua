-- Roman Test Task using algorithm that
-- convert it to arabic and then using
-- inverse transformation from arabic 
-- to roman


function ternary (cond, true_, false_)
    if cond then return true_ else return false_ end
end

function table_has_value (table, val)
    for key, value in pairs(table) do
        if key == val then
            return true
        end
    end

    return false
end

function roman_to_arabic(roman)
    local arabic = 0
    local roman_len = #roman
    local idx = 1
    
    roman_pairs = {
      ['I'] = 1,
      ['V'] = 5,
      ['X'] = 10,
      ['L'] = 50,
      ['C'] = 100,
      ['D'] = 500,
      ['M'] = 1000,
      ['IV'] = 4,
      ['IX'] = 9,
      ['XL'] = 40,
      ['XC'] = 90,
      ['CD'] = 400,
      ['CM'] = 900
    }
    
    while (idx <= roman_len)
    do
        if idx + 1 <= roman_len and table_has_value(roman_pairs, roman:sub(idx, idx + 1))
        then
            arabic = arabic + roman_pairs[roman:sub(idx, idx + 1)]
            idx = idx + 2
        else
            arabic = arabic + roman_pairs[roman:sub(idx, idx)]
            idx = idx + 1
        end
    end
    
    return arabic
end

function arabic_to_roman(arabic)
    local roman = ""
    
    local arabic_pairs = {
      {1000, "M"},
      {900, "CM"},
      {500, "D"},
      {400, "CD"},
      {100, "C"},
      {90, "XC"},
      {50, "L"},
      {40, "XL"},
      {30, "XXX"},
      {20, "XX"},
      {10, "X"},
      {9, "IX"},
      {5, "V"},
      {4, "IV"},
      {1, "I"}
    }
    
    for idx, item in ipairs(arabic_pairs) do
        while (arabic >= item[1])
        do
            arabic = arabic - item[1]
            roman = roman .. item[2]
        end
    end
    
    return roman
end


changes_count = 0
filename = "roman.txt"
output_filename = "roman_out_arabic.txt"

-- Open file
f = io.open(filename, "r")

-- Open output file
f_output = io.open(output_filename, "w")

-- Iterate over file
for line in f:lines() do
    local arabic = roman_to_arabic(line)
    local new_roman = arabic_to_roman(arabic)
    local len_diff = #line - #new_roman
    
    -- if we apply such transformation
    -- string len decrease
    changes_count = changes_count + len_diff
    f_output:write(string.format("%-16s %-10s %-16s %s", line, arabic, new_roman, ternary(len_diff > 0, "changed" ,"")), "\n")
end

print(string.format("Number of changed symbols: %s", changes_count))

-- Close file
f:close()

-- CLose output file
f_output:close()

