require_relative 'world'

target = "The ability to quote is a serviceable substitute for wit."
number_of_individuals = 64
mutation_frequency = 0.5
mutation_exposure = 0.05
mutation_size = 8
death_proportion = 0.25

puts "The target is: '#{target}'"
puts "Ready?"
gets

start_time = Time.now
world = World.new number_of_individuals, target

while world.fittest != world.target
  world.next_generation frequency: mutation_frequency, exposure: mutation_exposure, size: mutation_size
  world.sort_population
  world.cull_population death_proportion
  puts world.fittest
end
end_time = Time.now


result = "It took #{world.generation_number} generations to converge, in #{end_time - start_time} seconds."
puts
puts "=" * result.length
puts result
puts "=" * result.length
