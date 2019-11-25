require 'byebug'
require_relative 'node.rb'

class Queens
  def self.solve(n)
    @n = n
    @solution_count = 0

    

    board = draw_board(n)

    solve_board(board)
    p @solution_count
  end

  def self.solve_board(solution, depth=0, last_placed=nil) # backtrack
    if is_solution?(solution, depth)
      process_solution(solution, depth)
    else
      candidates = construct_candidates(solution, depth)

      if candidates.length == 0
        #un_place_queen(solution, last_placed)
        return
      end

      depth += 1
      candidates.each { |candidate| 
        new_solution = place_queen(solution, candidate)
        
        solve_board(new_solution, depth)
      }


    end
  end
  
  def self.un_place_queen(solution, candidate)
    candidate.terminator = false
    candidate.children.each { |node| node.terminator = false; node.value = "*" }
    candidate.value = '*'
    solution
  end

  def self.place_queen(solution, candidate)
    #again, solution is now a node. so:
    #this Marshalling is a trick; we should write a sensible ::clone method for Node
    #new_solution = Marshal.load(Marshal.dump(solution))
    
    new_solution = solution.clone
    solution.connect(new_solution)

    coord = candidate.location
    
    new_candidate = new_solution.value[coord[0]][coord[1]]
    #debugger
    new_candidate.terminator = true
    new_candidate.children.each { |node| node.terminator = true; node.value = "." }
    new_candidate.value = 'Q'

    
    new_solution
  end

  def self.is_solution?(solution, depth)
    depth == @n
  end

  def self.process_solution(solution, depth)
    @solution_count += 1
    print_board(solution)
  end

  def self.construct_candidates(solution, depth)
    #ok here "solution" is now a single node...
    #the code below works on its 'value'. so:
    board = solution.value
    
    board[depth].select { |node| node.terminator == false}
  end


  def self.print_board(solution)
    solution.value.each do |row|
      line = ''
      row.each do |column|
        line += column.value
      end
      p line
    end
    p "-"*32
    nil
  end

  def self.draw_board(n)
    #@coordinates = {}

    grid = Array.new(n) do |_i|
      Array.new(n) do |_i2|
        node = Node.new('*')
        node.location = [_i, _i2]
        #@coordinates[node] = [_i, _i2]
        node
      end
    end

    groups = collect_groups(n, grid)

    groups.each { |group|
      group.each { |line| 
        line.each_with_index { |node, idx|
          line[idx..-1].each { |child| node.connect(child) }
        }
      }
    }

    return Node.new(grid)
  end

  def self.collect_groups(n, grid)
    right_diags = []
    left_diags = []
    columns = grid.transpose

    n.times { |idx|
      right_diags << grid.each_with_index.collect { |subarr, i| subarr[i+idx] }.compact 
    }
    (n-1).times { |idx|
      right_diags << grid[idx+1..-1].each_with_index.collect { |subarr, i| 
        subarr[i] }
    }

    n.times { |idx|
      left_diags << grid.each_with_index.collect { |subarr, i| subarr[idx+n-i-1] }.compact
    }
    (n-1).times { |idx|
      left_diags << grid[0..-2-idx].each_with_index.collect { |subarr, i| 
        subarr[(n-i-2-idx) % (n-1)] }
    }

    
    return [right_diags, left_diags, columns]
  end
end

