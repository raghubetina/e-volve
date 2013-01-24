class Individual
  attr_accessor :genome

  def initialize(length)
    @genome = (1..length).map{ (32 + rand(95)).chr }.join
  end

  def mutate(options)
    @genome = @genome.split('').map { |char| rand < options[:exposure] ? [[(char.ord + rand(options[:size] * 2) - options[:size]), 32].max, 126].min.chr : char }.join
  end

  def score(target)
    target.split('').each_with_index.map { |char, i| (char.ord - @genome[i].ord).abs }.inject(:+)
  end
end
