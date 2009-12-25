class Perishable
  attr_accessor :name, :room, :fridge, :freezer,
                :major, :minor
  
  def initialize(maj, min)
    fix_type = Proc.new {|s| s.downcase.gsub(/\s/, '_').to_sym unless s.empty? }
    @major = fix_type.call(maj.to_s)
    @minor = fix_type.call(min.to_s)
    @room = @fridge = @freezer = @name = nil
  end

  def split
    return if @room == nil and @fridge == nil and @freezer == nil
    names = @name.split(',').map {|s| s.strip }
    @name = names.first
    newfoods = [self]
    names.delete_at(0)
    names.each do |n|
      p = Perishable.new(@major, @minor)
      p.fridge = @fridge
      p.freezer = @freezer
      p.room = @room
      p.name = n
      newfoods << p
    end
    return newfoods
  end

  def normalize
    @name.downcase!
    if @minor == @major
      @minor = nil
    end

    @major = @major.to_s.chomp('s').to_sym if @major
    @minor = @minor.to_s.chomp('s').to_sym if @minor
    
    if @room
      if @room[:num].class == Range
        case @room[:unit]
          when "day"
            @room = Range.new(@room[:num].first, @room[:num].last)
          when "week"
            @room = Range.new(@room[:num].first * 7, @room[:num].last * 7)
          when "month"
            @room = Range.new(@room[:num].first * 30, @room[:num].last * 30)
          when "year"
            @room = Range.new(@room[:num].first * 365, @room[:num].last * 365)
        end
      elsif @room[:num].class == Fixnum
        case @room[:unit]
          when "day"
            @room = @room[:num]
          when "week"
            @room = @room[:num] * 7
          when "month"
            @room = @room[:num] * 30
          when "year"
            @room = @room[:num] * 365
        end
      end
    end

    if @fridge
      if @fridge[:num].class == Range
        case @fridge[:unit]
          when "day"
            @fridge = Range.new(@fridge[:num].first, @fridge[:num].last)
          when "week"
            @fridge = Range.new(@fridge[:num].first * 7, @fridge[:num].last * 7)
          when "month"
            @fridge = Range.new(@fridge[:num].first * 30, @fridge[:num].last * 30)
          when "year"
            @fridge = Range.new(@fridge[:num].first * 365, @fridge[:num].last * 365)
        end
      elsif @fridge[:num].class == Fixnum
        case @fridge[:unit]
          when "day"
            @fridge = @fridge[:num]
          when "week"
            @fridge = @fridge[:num] * 7
          when "month"
            @fridge = @fridge[:num] * 30
          when "year"
            @fridge = @fridge[:num] * 365
        end
      end
    end

    if @freezer
      if @freezer[:num].class == Range
        case @freezer[:unit]
          when "day"
            @freezer = Range.new(@freezer[:num].first, @freezer[:num].last)
          when "week"
            @freezer = Range.new(@freezer[:num].first * 7, @freezer[:num].last * 7)
          when "month"
            @freezer = Range.new(@freezer[:num].first * 30, @freezer[:num].last * 30)
          when "year"
            @freezer = Range.new(@freezer[:num].first * 365, @freezer[:num].last * 365)
        end
      elsif @freezer[:num].class == Fixnum
        case @freezer[:unit]
          when "day"
            @freezer = @freezer[:num]
          when "week"
            @freezer = @freezer[:num] * 7
          when "month"
            @freezer = @freezer[:num] * 30
          when "year"
            @freezer = @freezer[:num] * 365
        end
      end
    end
  end
  
  def room_to_s
    return '' unless @room
    " room: #@room days"
  end

  def fridge_to_s
    return '' unless @fridge
    " fridge: #@fridge days"
  end

  def freezer_to_s
    return '' unless @freezer
    " freezer: #@freezer days"
  end

  def room=(room)
    if room.class == String
      @room = Perishable.timespan(room)
    else
      @room = room
    end
  end

  def fridge=(fridge)
    if fridge.class == String
      @fridge = Perishable.timespan(fridge)
    else
      @fridge = fridge
    end
  end

  def freezer=(freezer)
    if freezer.class == String
      @freezer = Perishable.timespan(freezer)
    else
      @freezer = freezer
    end
  end

  def to_s
      "#@name (#@major#{', ' + @minor.to_s if @minor})#{room_to_s}#{fridge_to_s}#{freezer_to_s}"
  end

  class << self  # class methods
    def timespan(str)
      return unless str
      matches = str.match(/(?:(\d+)\sto\s)?(\d+)\s(year|month|week|day)/) 
      return nil unless matches
      if matches[1] == nil
        return {:num => matches[2].to_i, :unit => matches[3]}
      else
        return {:num => Range.new(matches[1].to_i, matches[2].to_i), :unit => matches[3]}
      end
    end
  end
end
