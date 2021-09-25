-- Maze test task using BFS procedure, Lee (Wave) algorithm
-- https://ru.wikipedia.org/wiki/%D0%90%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC_%D0%9B%D0%B8

-- Vectors of movement in array
-- Up: (x, y) —> (x – 1, y) (0, 0, 1, 0)
-- Left: (x, y) —> (x, y – 1) (-1, 0, 0, 0)
-- Down: (x, y) —> (x + 1, y) (0, -1, 0, 0)
-- Right: (x, y) —> (x, y + 1) (0, 0, 0, 1)
row_vector = {-1, 0, 0, 1} --   -1 left; 1 right; 0 not move in direction
col_vector = {0, -1, 1, 0} --   -1 bottom; 1 top; 0 not move in direction

-- Maze from file
function read_maze_file(filename)
    local idx = 1
    local maze = {}
    local file= io.open(filename, "r")

    -- Read maze from file in 2D array
    for line in file:lines() do
        local t = {}
        line:gsub(".",function(c) table.insert(t, c) end)
        maze[idx] = t
        idx = idx + 1
    end

    file:close()
    
    return maze
end

-- Returns true if array is empty
function is_empty(arr)
    if next(arr) == nil then
      return true
    end
    
    return false
end

function find_start_end(maze_arr, rows, cols)
    local start_symbol = "I"
    local end_symbol = "E"
    
    -- Start and End indexes
    local start_idx = {}
    local end_idx = {}
    
    for row = 1, rows do
        if is_empty(start_idx) == false and is_empty(end_idx) == false then
            return start_idx, end_idx
        end
        
        for col = 1, cols do
            if maze_arr[row][col] == "I" then
                start_idx = {row, col}
            elseif maze_arr[row][col] == "E" then
              end_idx = {row, col}
            end
        end
    end
end

function print_2d_array(table_, rows, cols)
    for row = 1, rows do
        for col = 1, cols do
            io.write(table_[row][col])
        end
        print("")
    end
    print("\n")
end

function init_2d_array(rows, cols, val)
    local arr = {}
    
    for row = 1, rows do
        arr[row] = {}
        for col = 1, cols do
            arr[row][col] = val
        end
    end
    
    return arr
end

function is_cell_in_maze(row_idx, col_idx, rows, cols)
    return row_idx >= 1 and col_idx >= 1 and row_idx <= rows and col_idx <= cols
end

function fill_maze_path(maze_arr, maze_path, fill_symbol)
    for arr_idx, cell in ipairs(maze_path) do
        maze_arr[cell[1]][cell[2]] = fill_symbol
    end
    
    return maze_arr
end

function get_free_neighbor_cells(maze_arr, rows, cols, cell)
    local x, y
    x, y = cell[1], cell[2]
    
    local neighbors = {}
    
    for step = 1, 4 do
        local neight_row = x + row_vector[step]
        local neight_col = y + col_vector[step]
        
        if (is_cell_in_maze(neight_row, neight_row, rows, cols)) and
            maze_arr[neight_row][neight_col] == " " or
            maze_arr[neight_row][neight_col] == "I"
        then
              table.insert(neighbors, {neight_row, neight_col})
        end
    end
    
    return neighbors
end

-- Compare tables
function compare(arr1, arr2)
    if #arr1 ~= #arr2 then
        return false
    end
        
    for idx = 1, #arr1 do
        if arr1[idx] ~= arr2[idx] then
            return false
        end
    end
    
    return true
end

function find_neighbor_dist(neighbor, paths)
    for idx = #paths, 1, -1 do
        if compare(paths[idx][1], neighbor) then
            return paths[idx][2]
        end
    end
    
    return -1
end

-- Backtracing
-- go to the target point
--   REPEAT
--     - go to neighbor cell that has a lower dist (dist - 1) than the cell
--     - add this cell to path
--   UNTIL (start point reached)
function backtracing(path_coords, cell, dist)
    local current_cell = cell
    local current_dist = dist
    local final_path = {}
    while (compare(current_cell, st) == false)
    do
        local neighbors = get_free_neighbor_cells(maze, rows, cols, current_cell)
        
        for idx = 1, #neighbors do
            local neighbor = neighbors[idx]
            local neighbor_dist = find_neighbor_dist(neighbor, path_coords)
            
            if current_dist - neighbor_dist == 1 then
                table.insert(final_path, neighbor)
                current_cell = neighbor
                current_dist = neighbor_dist
                break
            end
        end
    end

    table.remove(final_path, #final_path)
    
    return final_path
end

function write_maze_file(filename, maze_arr, rows, cols)
    local file = io.open(filename, "w")
    
    for row = 1, rows do
        local s = ""
        for col = 1, cols do
            s = s .. maze_arr[row][col]
        end
        file:write(s, "\n")
    end
    
    file:close()
end


-- Create Queue to use it in BFS
Queue = {}
function Queue.new(s)
    return {s}
end
    
function Queue.add(queue, val)
    table.insert(queue, val)
end

function Queue.pop(queue)
    return table.remove(queue, 1)
end

-- Return true if empty
function Queue.empty(queue)
    return is_empty(queue)
end


function maze_path_bfs(maze_arr, rows, cols, st_point, en_point)
    -- Path arr
    local path_arr = {}
  
    -- Init with start cell and destination path len
    -- First we have start point and 0
    local coord_queue = Queue.new({st_point, 0})
    
    local current_cell
    
    -- Init array with visited cells and start_point
    local visited_cells = init_2d_array(rows, cols, false)
    visited_cells[st_point[1]][st_point[2]] = true
    
    while (Queue.empty(coord_queue) == false)
    do
        local current_cell = Queue.pop(coord_queue)
        
        local current_cell_point = current_cell[1]
        local current_cell_dist = current_cell[2]
        
        table.insert(path_arr, current_cell)
        
        -- Stop search if we reach destination point
        if current_cell_point[1] == en_point[1] and current_cell_point[2] == en_point[2] then
            return path_arr, current_cell_dist
        end
        
        for step = 1, 4 do
            local new_row_idx = current_cell_point[1] + row_vector[step]
            local new_col_idx = current_cell_point[2] + col_vector[step]
            
            -- Check if new cell in maze or visited
            if (is_cell_in_maze(new_row_idx, new_col_idx, rows, cols)) and
                (maze_arr[new_row_idx][new_col_idx] == " " or
                  maze_arr[new_row_idx][new_col_idx] == "E") and
                (visited_cells[new_row_idx][new_col_idx] == false) 
                then
                    visited_cells[new_row_idx][new_col_idx] = true
                    Queue.add(coord_queue, {{new_row_idx, new_col_idx}, current_cell_dist + 1})
            end
        end
    end
    
    return path_arr, -1
end



-- MAIN PART
maze_filename = "maze.txt"
new_maze_filename = "maze_out.txt"

-- Read maze from file in 2D array
maze = read_maze_file(maze_filename)

-- 2D array size
rows, cols = #maze, #maze[1]

print("MAZE:")
print_2d_array(maze, rows, cols)

-- Start and End points for maze
st, en = find_start_end(maze, rows, cols)

-- Find path in maze using Lee algorithm and BFS
path_coords, path_len = maze_path_bfs(maze, rows, cols, st, en)

-- Backtracing to find final shortest path
final_cell = en
final_dist = path_len
final_path = backtracing(path_coords, final_cell, final_dist)

-- Fill maze with path
new_maze = fill_maze_path(maze, final_path, "@")

print(string.format("MAZE WITH PATH (SHORTEST PATH LEN = %s):", path_len, path_len - 2))
print_2d_array(new_maze, rows, cols)

-- Save in new file
write_maze_file(new_maze_filename, new_maze, rows, cols)
