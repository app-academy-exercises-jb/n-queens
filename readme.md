The solutions to the first 8 n-queens problems are in the solution folder. To see a sample of that generated output:

    ruby 'solve.rb'

As the latest in the graph theory flavored problem in the exercises, we will solve n-queens using our familiar Node object to create a graph representing an n-sized chess board, where each node is a position on the board, whose children are positions which would be threatened by a queen in that position. We will utilize a solution known as backtracking, which will also create a graph, but one in which each node represents a decision tree of queens which have been put down. 

As it is, our implementation is quite slow. n = 6 takes just 20 seconds, but n = 8 takes about 20 minutes. Currently our bottleneck is our inability to easily do deep clones of our board objects.

Class usage is as follows:

    Queens.solve(n)

It will print out the solved board.


