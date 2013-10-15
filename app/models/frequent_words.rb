# encoding: utf-8

class FrequentWords

  include ActiveModel::Validations
  include ActiveModel::Serialization

  cattr_writer :scan_for
  attr_writer :scan_for
  attr_accessor :text, :result

  validates_presence_of :text

  def initialize(args={})
    self.result = {}
    args.each_pair do |key, val|
      raise "Invalid argument '#{key}' for #{self.class}" until respond_to? "#{key}="
      send "#{key}=", val
    end
  end

  def self.scan_for
    @@scan_for || /\p{L}+/
  end

  def scan_for
    @scan_for || self.class.scan_for
  end

  # Scans for words matching scan_for pattern and returns hash with 5 most frequent words
  #
  # Arguments:
  # text     - The source text (Required)
  # scan_for - Scan pattern, fefault - FrequentWords.scan_for (Optional)

  def execute
    return false unless valid?

    r = {}
    text.scan(scan_for) do |word|
      r[word] = 0 unless r.key? word
      r[word] += 1
    end
    @result = Hash[ r.to_a.sort{|x,y| y[1]<=>x[1]}[0..4] ]
  end

  def to_hash
    errors.any? ? {errors: errors.to_hash} : @result
  end

end