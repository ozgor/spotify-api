#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), *%w[lastfm])
require File.join(File.dirname(__FILE__), *%w[spotify])

# a demo app which grabs tracks from last.fm and creates a spotify 
# playlist based on friends loved tracks
if __FILE__ == $0
  username = ARGV.shift or raise "#{$0} <username>"
  
  puts "fetching last.fm tracks (friends/recently_loved)"
  tracks = LastFM.friends_loved_tracks(username).values.flatten
  
  puts "resolving spotify ids"  
  spotify_tracks = Spotify.resolve(tracks.maps {|t| [t["title"], t["artist"]] })
  
  #puts "found tracks: #{spotify_tracks.inspect}"
  if spotify_tracks.size > 0
    puts "creating playlist with #{spotify_tracks.size} tracks"
    puts Spotify.create_playlist(username, spotify_tracks.map { |t| t['id'] })  
  end
end