require 'rubygems'
require 'git'
require 'set'
require 'yaml'
require_relative 'pair_tuple'
require_relative 'settings'
require_relative 'fuzzy_string_matcher'
require_relative 'report'

VERY_LARGE_NUMBER = 999999

class PairingMatrixGenerator
  
  def initialize
    @tuples = Set.new
  end

  def authors_master
    config.authors.split(",").map(&:strip)
  end
  
  def pair_tuples
    commits.each do |commit|
      pair = commit.message.scan config.commit_pattern #extract pair from commit message by regex pattern
      date = commit.date.strftime("%m-%d-%y")
      @tuples.add PairTuple.new(date, pair.first) unless pair.empty?
    end
    @tuples
  end
  
  def group_by_pair
    grouped =  pair_tuples.group_by {|el| el.authors}
    grouped.map {|k,v| [k, v.length]}
  end
  
  def generate_matrix
    actual_pair_tuple = apply_name_approximation group_by_pair
    
    html_table = {}
    authors_master.each do |author|
      row = Hash.new(0)
      actual_pair_tuple.delete_if do |tuple|
        pair = tuple.first
        count = tuple.last
        if pair.include? author
          other =  (pair - [author]).first
          row[other] += count 
          true
        else
          false
        end
      end
      html_table[author] = row
    end
    Reports.generate_table(authors_master, html_table)
  end 
  
  private
  
  def apply_name_approximation(pair_groups)
    @matcher ||= FuzzyStringMatcher.new authors_master
    pair_groups.collect do |pair_tuple|
      approx_pair =  pair_tuple.first
      count = pair_tuple.last
      actual_pair = [@matcher.match(approx_pair.first), @matcher.match(approx_pair.last)]
      [actual_pair, count]
    end
  end
  
  def commits
    commits = [] 
    config.repositories.each do |repo_name|
      git = Git.open repo_name
      git.log(VERY_LARGE_NUMBER).each do |commit|
        commits << commit
      end  
    end 
    commits
  end
  
  def config
    @config ||= Settings.new('config.yml')
  end
  
end

pmgen = PairingMatrixGenerator.new
pmgen.generate_matrix