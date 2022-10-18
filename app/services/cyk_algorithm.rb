
class CykService

    def initialize(grammar, word)
        @grammar = grammar
        @word = word
    end
    
    # CYK Algorithm base on TI document
    # In order to apply CYK algorithm to a grammar, it must be in 
    # Chomsky Normal Form. It uses a dynamic programming algorithm to 
    # tell whether a string is in the language of a grammar.
    # Output:
    # +boolean+:: w ∈ L(G)siys ́olosiS ∈ X1n.
    def algorithm
        # Gets matrix size base in word provide by client app
        n = @word.length
        # Create n * n table or multi-dimesional array
        grid = Array.new(n) { Array.new(n)}
        # Fill first column looking its corresponding producer of each terminal
        @word.split("").each_index{ |i|
            grid[i][0] = self.getProducers(@word[i])
        }
        # 
        (1..n-1).each do |j|   # 0 index adpater (j=n)
            (0..n-j-1).each do |i| # 0 index adapter (1 <= i <= n-j+1)
                temp = Array.new() # Sets of elements such as B ∈ X_ik and C ∈ X_(i+k)(j-k)
                (0..j-1).each do |k| # 0 index adapter (1 <= k < j-1)
                    temp.push(self.concatenate(grid[i][k],grid[i+k+1][j-k-1])) # Push works like a union between concatenates
                end  
                prop = Array.new() # Set of variables A -> a_i -> BC 
                temp.map{|e| e.split().map{|element| prop.push(self.getProducers(element))}}
                grid[i][j] = prop
            end
        end
        puts(grid) # Debugging Result
        return (grid[0][n-1].join.include? 'S')
    end

    private def getProducers(product)
        return @grammar.select{|element| 
            element[:products].include?(product)}.map{|element| 
                element[:producer]}
    end

    private def concatenate(prefix, sufix)
        pre = prefix.dup
        su = sufix.dup
        arr = ''
        comma = ''
        if (pre and su)
            pre.each_index{|productionP| 
                su.each_index{|productionS| 
                    begin
                        # Concatenation with a string
                        arr += comma + pre[productionP] + su[productionS]
                    rescue
                        begin
                            # Concatenation with an array
                            arr += comma + pre[productionP][0] + su[productionS][0]
                        rescue
                            # Concatenation with a nil value (empty set)
                            arr += comma
                        end
                    end
                    comma = ' '
                }}
            return arr
        end
        return comma
    end

end
