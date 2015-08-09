require 'sqlite3'
class Edict


 @@db
  
  def self.test 
    SQLite3::Database.new('db/kuku.db' ) do |db|
      db.execute( "select * from entry" ) do |row|
        p row
      end
    end
  end
  
  def self.execute(param, &block)
    @@db ||= SQLite3::Database.new 'db/kuku.db'
    @@db.execute param, &block
  end
  
  def self.meaning(word)
    puts "aaaaaaaaaaaaaaaaaaaaaaaaa"
    rez = [];
    execute "SELECT entry.id, entry.ent_seq
FROM entry
LEFT JOIN k_ele ON entry.id = k_ele.fk
WHERE k_ele.value = \"#{word}\" ;" do |row|
      n = [];
      puts row
      n[0] = execute "SELECT DISTINCT r_ele.value
FROM entry
LEFT JOIN r_ele ON entry.id = r_ele.fk
WHERE entry.id = #{row[0]};"
      
      
      a = []
      execute  "SELECT DISTINCT gloss.value, gloss.lang
FROM entry
LEFT JOIN sense ON entry.id = sense.fk
LEFT JOIN gloss ON sense.id = gloss.fk
WHERE entry.id = #{row[0]};" do |f|
        a << f[0]
      end 
      n[1] = a
      rez << n;  
    end
    return rez
  end
  
  def self.meaning_by_hiragana(word)
    puts "aaaaaaaaaaaaaaaaaaaaaaaaa"
    rez = [];
    execute "SELECT entry.id, entry.ent_seq
FROM entry
LEFT JOIN r_ele ON entry.id = r_ele.fk
WHERE r_ele.value = \"#{word}\" ;" do |row|
      n = [];
      puts "row --> #{row}, row[0] --> #{row[0]}"
      n[0] = word 
      
      a = []
      execute  "SELECT DISTINCT gloss.value, gloss.lang
FROM entry
LEFT JOIN sense ON entry.id = sense.fk
LEFT JOIN gloss ON sense.id = gloss.fk
WHERE entry.id = #{row[0]};" do |f|
 puts "f --> #{f}"
        a << f[0]
      end 
      n[1] = a
      rez << n;  
    end
    return rez
  end
  
def self.getpos_id(word) 
  rez = []
  execute "SELECT entry.id, k_ele.value, entry.ent_seq
FROM entry
LEFT JOIN k_ele ON entry.id = k_ele.fk
WHERE k_ele.value = \"#{word}\";" do |row|
    puts row
    rez << (execute "SELECT distinct pos.entity
FROM entry
left join sense on entry.id = sense.fk
left join pos on sense.id = pos.fk
WHERE entry.id = #{row[0]};")[0][0]
  end
  return rez
end

def self.is_noun?(word) 
  a = self.getpos_id(word)
  
  [119, 167, 167, 41, 119].each {
    |x| 
    return true if a.include? x
  }
  
  return false
end

def self.is_verb?(word)
  a = self.getpos_id(word)
  a.each {
    |x|
    entity = Edict.execute "SELECT entity from entity where id = #{x};"
    return true if entity[0][0][0] == 'v'
  }
  return false
end

end
