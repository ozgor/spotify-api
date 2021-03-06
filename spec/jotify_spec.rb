#!/usr/bin/env jruby -S spec
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'jotify'

describe Jotify do  
  
  before(:each) do
    @jotify_impl = mock('JotifyImpl')
    @jotify_impl.stub!(:login)
    @jotify = Jotify.new(@jotify_impl)
  end  
  
  it "should resolve ids" do    
    { "spotify:user:flumix:playlist:2mnbxTkghYtlHMdX3jdP9C" => "4d921ebcdd8c80f32ce1ed5acafbb9c8",
      "http://open.spotify.com/user/flumix/playlist/2mnbxTkghYtlHMdX3jdP9C" => "4d921ebcdd8c80f32ce1ed5acafbb9c8",
      "2mnbxTkghYtlHMdX3jdP9C" => "4d921ebcdd8c80f32ce1ed5acafbb9c8",
      "4d921ebcdd8c80f32ce1ed5acafbb9c8" => "4d921ebcdd8c80f32ce1ed5acafbb9c8"
    }.each { |id, expected| Jotify.resolve_id(id).should == expected }
  end
  
  it "should set tracks on playlist" do    
    @playlist = Jotify::Media::Playlist.new
    @jotify_impl.should_receive(:playlistAddTracks) do |playlist, tracks, pos|
      playlist.should be_a(Jotify::Media::Playlist)
      #playlist.should == @playlist
      pos.should == 0
      tracks.should be_an(Java::JavaUtil::List)
      tracks.size.should == 1
    end
    @jotify.set_tracks_on_playlist(@playlist, ['4d921ebcdd8c80f32ce1ed5acafbb9c8'])
  end    
  
  it "should remove tracks before setting tracks on playlist" do    
     @playlist = Jotify::Media::Playlist.new
     @playlist << empty_track
     @jotify_impl.should_receive(:playlistRemoveTracks).and_return(true)
     @jotify_impl.should_receive(:playlistAddTracks) do |playlist, tracks, pos|
       playlist.should be_a(Jotify::Media::Playlist)
       #playlist.should == @playlist
       pos.should == 1
       tracks.should be_an(Java::JavaUtil::List)
       tracks.size.should == 1
     end
     @jotify.set_tracks_on_playlist(@playlist, ['4d921ebcdd8c80f32ce1ed5acafbb9c8'])
   end
   
  it "should rename the playlist" do
   @playlist = Jotify::Media::Playlist.new
   @jotify_impl.should_receive(:playlistRename).with(anything(), 'new').and_return(true)
   @jotify.rename_playlist(@playlist, 'new').should == true
  end
   
   
  it "should rename the playlist" do
    @playlist = Jotify::Media::Playlist.new
    @jotify_impl.should_receive(:playlistSetCollaborative).with(anything(), true).and_return(true)
    @jotify.set_collaborative_flag(@playlist, true).should == true
  end
end