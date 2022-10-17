require 'simple_command'

class CykService
    prepend SimpleCommand

    def initialize(grammar, word)
        @grammar = grammar
        @word = word
    end

    # instance and class methods above
    private

    def algorithm()
        n = @word.length
        #Create n * n table or multi-dimesional array
        grid = Array.new(n) { Array.new(n)}
        @word.split("").each_index{ |i|
            grid[i][0] = self.class.getProducers(@word[i])
        }
        (1..n).each do |j|
            (0..n-j+1).each do |i|
                temp = new Set()
                (0..j-1).each do |k|
                    temp.add(self.class.concatenate(grid[i][k],grid[i+k][j-k]))
                end
                grid[i][j] = temp
            end
        end
    end

    def getProducers(product)
        return @grammar.select{|element| 
            element.products.include?(product).map{|element| 
                element.producer}}.to_set
    end

    def concatenate(prefix, sufix)
        set = new Set()
        prefix.each(|productionP| sufix.each(|productionS| set.add([productionP,productionS])))
        return set
    end

end
