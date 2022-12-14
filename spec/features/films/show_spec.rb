require 'rails_helper'

RSpec.describe 'Film Show Page' do
  before(:each) do 
    @c_eastwood = Director.create!(name: 'Clint Eastwood',best_director_oscars: 2 ,multiple_best_director_nominations: true)
    @k_bigelow = Director.create!(name: 'Kathryn Bigelow',best_director_oscars: 1,multiple_best_director_nominations: false)
    @s_kubrick = Director.create!(name: 'Stanley Kubrick',best_director_oscars: 0,multiple_best_director_nominations: true)
    @s_spielberg = Director.create!(name: 'Steven Spielberg',best_director_oscars: 2 ,multiple_best_director_nominations: true)
    
    @million_dollar_baby = @c_eastwood.films.create!(name:'Million Dollar Baby', release_year: 2004, best_picture_oscar: true)
    @mystic_river = @c_eastwood.films.create!(name:'Mystic River', release_year: 2003, best_picture_oscar: false)
    @perfect_world = @c_eastwood.films.create!(name:'A Perfect World', release_year: 1993, best_picture_oscar: false)
    @true_crime = @c_eastwood.films.create!(name:'True Crime', release_year: 1999, best_picture_oscar: false)
    @unforgiven = @c_eastwood.films.create!(name:'Unforgiven', release_year: 1992, best_picture_oscar: true)
    
    @hurt_locker = @k_bigelow.films.create!(name:'The Hurt Locker', release_year: 2008, best_picture_oscar: true)
    @loveless = @k_bigelow.films.create!(name:'The Loveless', release_year: 1981, best_picture_oscar: false)
    @zero_dark_thirty = @k_bigelow.films.create!(name:'Zero Dark Thirty', release_year: 2012, best_picture_oscar: false)
    
    @clockwork_orange = @s_kubrick.films.create!(name:'A Clockwork Orange', release_year: 1971, best_picture_oscar: false)
    @eyes_wide_shut = @s_kubrick.films.create!(name:'Eyes Wide Shut', release_year: 1999, best_picture_oscar: false)
    @fear_and_desire = @s_kubrick.films.create!(name:'Fear and Desire', release_year: 1952, best_picture_oscar: false)
    
    @firelight = @s_spielberg.films.create!(name:'Firelight', release_year: 1964, best_picture_oscar: false)
    @jurassic_park = @s_spielberg.films.create!(name:"Jurassic Park", release_year: 1993, best_picture_oscar: false)
    @schindlers_list = @s_spielberg.films.create!(name:"Schindler's List", release_year: 1993, best_picture_oscar: true)
  end

  describe 'User Story 4' do
    it "displays a specific film's attributes" do
      visit ("/films/#{@jurassic_park.id}")
      
      expect(page).to_not have_content(@schindlers_list.name)
      expect(page).to_not have_content(@mystic_river.release_year) 
      expect(page).to_not have_content(@hurt_locker.best_picture_oscar)
      expect(page).to_not have_content(@clockwork_orange.director.name)

      expect(page).to have_content(@jurassic_park.name)
      expect(page).to have_content(@jurassic_park.release_year) 
      expect(page).to have_content(@jurassic_park.best_picture_oscar)
      expect(page).to have_content(@jurassic_park.director.name)
    end

    it "sends user to the film director's show page when the director's name is click" do      
      visit ("/films/#{@clockwork_orange.id}")
      
      click_on ('Stanley Kubrick')
      
      expect(current_path).to_not eq("/films/#{@clockwork_orange.id}")
      expect(current_path).to_not eq("/directors")

      expect(current_path).to eq("/directors/#{@clockwork_orange.director.id}")
    end
  end


end