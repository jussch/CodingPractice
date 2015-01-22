module TracksHelper
  def ugly_lyrics(text)
    text.split("\n").map{ |line| "♫" + line }.join("\n")
  end
end
