# // For each chord generate all others and assign the pitch and type

pitch = {
    0 => "c",
    1 => "c-sharp",
    2 => "d",
    3 => "e-flat",
    4 => "e",
    5 => "f",
    6 => "f-sharp",
    7 => "g",
    8 => "a-flat",
    9 => "a",
    10 => "b-flat",
    11 => "b"
}

types = {
    0 => "maj",
    1 => "min",
    2 => "dim",
    3 => "aug",
}

# // For each collection, take all other valid notes in that chord, then record all possible combinations of that 
# // Collection. 

# // Give it all 109736 combinations of 88C3 and have it learn the chord unsupervised. This is better.

chords = [
    [0, 4, 7],
    # // [4, 7, 12],
    # // [7, 12, 16],
    [0, 3, 7],
    # // [3, 7, 12],
    # // [7, 12, 15],
    [0, 3, 6],
    [0, 4, 8],
]

all_chords = []

[[0, 4, 7], [0, 3, 7]].each_with_index do |chord, type|
    (0..11).each do |pitch_center|
       p = chord.dup.map{|pitch| pitch + pitch_center}
       while p[-1] < 88
          p.concat(p[-3..-1].map{|pitch| pitch + 12})
       end
       while p[-1] > 87
          p.pop 
       end
       p.combination(3).each do |c|
          if c[0] == [10,78,86]
           p c 
           p pitch_center
           p type
          end
          all_chords << [c, pitch_center + (12*type)]
       end
    end

end

[[0, 3, 6]].each_with_index do |chord, type|
    (0..2).each do |pitch_center|
       p = chord.dup.map{|pitch| pitch + pitch_center}
       while p[-1] < 88
          p.concat(p[-3..-1].map{|pitch| pitch + 9})
       end
       while p[-1] > 87
          p.pop 
       end
       p.combination(3).each do |c|
          all_chords << [c, c[0]%12 + type + (12*2)]
       end
    end

end

[[0, 4, 8]].each_with_index do |chord, type|
    (0..3).each do |pitch_center|
       p = chord.dup.map{|pitch| pitch + pitch_center}
       while p[-1] < 88
          p.concat(p[-3..-1].map{|pitch| pitch + 12})
       end
       
       while p[-1] > 87
          p.pop 
       end
       p.combination(3).each do |c|
          all_chords << [c, c[0]%12 + type + (12*3)]
       end
    end

end

require 'csv'
CSV.open("chords.csv", "w") do |csv|
   # only want the chords that don't have repeated notes.
   # Where no two chords can be mod by 12
   all_chords.select{|chord| chord[0][0]%12 != chord[0][1]%12 && 
                             chord[0][0]%12 != chord[0][2]%12 && 
                             chord[0][1]%12 != chord[0][2]%12 }
      .shuffle.each{|c| csv << c[0].concat([c[1]])}
#   csv << ["row", "of", "CSV", "data"]
#   csv << ["another", "row"]
  # ...
end
#%% Now if i convert each of these numerical to a 88 feature vector, then I can store these in .mat files 
#%% them into the network, and tain the neural network 

# let's say the netowkr is 88 * 12 * 48
# save it as csv and we're all good.
