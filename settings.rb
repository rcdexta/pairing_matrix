class Settings

  def initialize(yaml_file)
    @data = {}
    hash = Psych.load(File.read(File.join(File.dirname(File.expand_path(__FILE__)), yaml_file)))
    update!(hash)
  end

  def update!(data)
    data.each do |key, value|
      self[key] = value
    end
  end

  def [](key)
    @data[key.to_sym]
  end

  def []=(key, value)
      @data[key.to_sym] = value
  end

  def method_missing(sym, *args)
    if sym.to_s =~ /(.+)=$/
      self[$1] = args.first
    else
      self[sym]
    end
  end

end