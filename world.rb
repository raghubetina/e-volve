require_relative 'individual'

class World
  attr_accessor :population, :generation_number, :target

  def initialize(number_of_individuals, target)
    @population = Array.new(number_of_individuals) { Individual.new(target.length) }
    @generation_number = 1
    @target = target
  end

  def next_generation(options)
    @population.map { |ind| ind.mutate exposure: options[:exposure], size: options[:size] if rand < options[:frequency] }
    @generation_number += 1
  end

  def sort_population
    @population.sort! { |ind1, ind2| ind1.score(@target) <=> ind2.score(@target) }
  end

  def cull_population(proportion)
    number_of_deaths = (@population.length * proportion).floor
    @population.fill(-number_of_deaths..-1) { @population.first.dup }
  end

  def genomes
    @population.map(&:genome)
  end

  def fittest
    @population.first.genome
  end
end
