require 'test/unit'
require_relative 'world'

class TestWorld < Test::Unit::TestCase
  def setup
    @world = World.new 3, "The ability to quote"
  end

  def assert_all_individuals_in_population_are_unique(world)
    assert_equal world.population.length, world.population.map(&:object_id).uniq.length
  end

  def test_initialize_creates_unique_individuals_in_population
    assert_all_individuals_in_population_are_unique @world
  end

  def test_initialize_starts_generation_number_at_1
    assert_equal 1, @world.generation_number
  end

  def test_initialize_sets_target
    assert_equal "The ability to quote", @world.target
  end

  def test_next_generation_creates_unique_individuals_in_population
    @world.next_generation frequency: 1.0, exposure: 0.25, size: 8
    assert_all_individuals_in_population_are_unique @world
  end

  def test_next_generation_mutates_population_genomes
    first_generation_genomes = @world.genomes
    @world.next_generation frequency: 1.0, exposure: 0.25, size: 8
    assert_not_equal first_generation_genomes, @world.genomes

    second_generation_genomes = @world.genomes
    @world.next_generation frequency: 1.0, exposure: 0.25, size: 8
    assert_not_equal second_generation_genomes, @world.genomes
  end

  def test_next_generation_increments_generation_number
    @world.next_generation frequency: 1.0, exposure: 0.25, size: 8
    assert_equal 2, @world.generation_number

    @world.next_generation frequency: 1.0, exposure: 0.25, size: 8
    assert_equal 3, @world.generation_number
  end

  def test_sort_population
    @world.population[0].genome = "The frailty to laugh"
    @world.population[1].genome = "The ability to laugh"
    @world.population[2].genome = "The ability to quote"

    @world.sort_population
    assert_equal ["The ability to quote", "The ability to laugh", "The frailty to laugh"], @world.genomes
  end

  def test_cull_population_fills_with_high_proportion
    @world.population[0].genome = "The frailty to laugh"
    @world.population[1].genome = "The ability to laugh"
    @world.population[2].genome = "The ability to quote"

    @world.sort_population
    @world.cull_population 0.8
    assert_equal ["The ability to quote", "The ability to quote", "The ability to quote"], @world.genomes
  end

  def test_cull_population_fills_with_low_proportion
    @world.population[0].genome = "The frailty to laugh"
    @world.population[1].genome = "The ability to laugh"
    @world.population[2].genome = "The ability to quote"

    @world.sort_population
    @world.cull_population 0.4
    assert_equal ["The ability to quote", "The ability to laugh", "The ability to quote"], @world.genomes
  end

  def test_cull_population_creates_unique_individuals_in_population
    @world.cull_population 0.8
    assert_all_individuals_in_population_are_unique @world
  end
end

class TestIndividual < Test::Unit::TestCase
    def setup
      @ind1 = Individual.new 20
      @ind2 = Individual.new 20
    end

    def assert_all_genes_are_within_bounds(ind)
      assert ind.genome.split('').map(&:ord).max <= 126
      assert ind.genome.split('').map(&:ord).min >= 32
    end

    def test_initialize_creates_random_genomes
      assert_not_equal @ind1.genome, @ind2.genome
    end

    def test_initialize_creates_genome_with_correct_length
       assert_equal 20, @ind1.genome.length
    end

    def test_initialize_creates_legal_genes
      assert_all_genes_are_within_bounds @ind1
      assert_all_genes_are_within_bounds @ind2
    end

    def test_mutate_changes_genome
      original_genome = @ind1.genome
      @ind1.mutate exposure: 0.5, size: 8
      assert_not_equal original_genome, @ind1.genome
    end

    def test_mutate_creates_legal_genes
      @ind1.mutate exposure: 0.5, size: 8
      @ind2.mutate exposure: 1.0, size: 300

      assert_all_genes_are_within_bounds @ind1
      assert_all_genes_are_within_bounds @ind2
    end

    def test_score
      @ind1.genome = "b;*nAV=_J[X@?aMUwa84"
      @ind2.genome = "The ability to quotf"

      assert_equal 683, @ind1.score("The ability to quote")
      assert_equal 1, @ind2.score("The ability to quote")
    end
end
